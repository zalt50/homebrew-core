class Fastly < Formula
  desc "Build, deploy and configure Fastly services"
  homepage "https://www.fastly.com/documentation/reference/cli/"
  url "https://github.com/fastly/cli/archive/refs/tags/v15.3.0.tar.gz"
  sha256 "a6a90ae1bbf64d3676920d35b84db5d711414f9db38f1b2d524bc7822ee48e01"
  license "Apache-2.0"
  head "https://github.com/fastly/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32c31f6a7f02fdf6dc215df2bc0f445972b5088d54843af0317c823b85b6d849"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32c31f6a7f02fdf6dc215df2bc0f445972b5088d54843af0317c823b85b6d849"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32c31f6a7f02fdf6dc215df2bc0f445972b5088d54843af0317c823b85b6d849"
    sha256 cellar: :any_skip_relocation, sonoma:        "5739a0f0860c34258dff903e3a5119dd60b6d7f9295ed11c9ff58619c2a28dd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f62715ee374e6778f612d2de061554777f08f5ed4757eaa3b7bd887ead096e7e"
    sha256 cellar: :any,                 x86_64_linux:  "9549fc7e333ad0a7a8c1697227cd1f97b400478ccd160fe6fedccd8a431d557b"
  end

  depends_on "go" => :build

  def install
    mv ".fastly/config.toml", "pkg/config/config.toml"

    os = Utils.safe_popen_read("go", "env", "GOOS").strip
    arch = Utils.safe_popen_read("go", "env", "GOARCH").strip

    ldflags = %W[
      -s -w
      -X github.com/fastly/cli/pkg/revision.AppVersion=v#{version}
      -X github.com/fastly/cli/pkg/revision.GitCommit=#{tap.user}
      -X github.com/fastly/cli/pkg/revision.GoHostOS=#{os}
      -X github.com/fastly/cli/pkg/revision.GoHostArch=#{arch}
      -X github.com/fastly/cli/pkg/revision.Environment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/fastly"

    generate_completions_from_executable(bin/"fastly", shell_parameter_format: "--completion-script-",
                                                       shells:                 [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fastly version")

    ENV["FASTLY_API_TOKEN"] = "invalid-token"
    output = shell_output("#{bin}/fastly service list 2>&1", 1)
    assert_match "401 Unauthorized", output
  end
end
