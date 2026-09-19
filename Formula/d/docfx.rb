class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/archive/refs/tags/v2.78.6.tar.gz"
  sha256 "6ea189a4bc71e04684acc92f26c1c79bda5d8a8756208ab79889b64cca771648"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "31319b84a8a928b6751b8eb5d389a2b1173c163767bab586829440d2acc74f1e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b368d1717ab79019400da37b567c24bbb95bf7d1efaad119eecf0f9fc0ca9727"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "da8b027ac0c9de8fc4d9bda5bcade890925a26adaf249ecaefd5b1546711c197"
    sha256 cellar: :any,                 arm64_linux:       "29571b87852fb2af36f6efbffea4383c609ebe58f3432fffd8e2e5ae845a99d5"
    sha256 cellar: :any,                 x86_64_linux:      "9bd0a06a84f47061ef2cc452a1b23f2b98f1bc4d5fcecb061ff978250150a0e3"
  end

  depends_on "node" => :build
  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    dotnet = Formula["dotnet"]

    # specify the target framework to only target the currently used version of
    # .NET, otherwise additional frameworks will be added due to this running
    # inside of GitHub Actions, for details see:
    # https://github.com/dotnet/docfx/blob/main/Directory.Build.props#L3-L5
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:Version=#{version}
      -p:TargetFrameworks=net#{dotnet.version.major_minor}
    ]

    cd "templates" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end
    system "dotnet", "publish", "src/docfx", *args

    (bin/"docfx").write_env_script libexec/"docfx",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    # The sandbox denies FSEvents, so .NET's config file watcher would hang
    ENV["DOTNET_USE_POLLING_FILE_WATCHER"] = "1" if OS.mac?

    system bin/"docfx", "init", "--yes", "--output", testpath/"docfx_project"
    assert_path_exists testpath/"docfx_project/docfx.json", "Failed to generate project"
    assert_match "modern", shell_output("#{bin}/docfx template list")
  end
end
