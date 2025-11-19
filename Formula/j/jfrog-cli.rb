class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.84.0.tar.gz"
  sha256 "64b00022f0ccb05fe3a1a35ca9e9c9595925a0827814aefbf22e439ac382cfd5"
  license "Apache-2.0"
  head "https://github.com/jfrog/jfrog-cli.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b82125bd4890eda63997154ed85ccc314724990869911a715c03ac64b6f618d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b82125bd4890eda63997154ed85ccc314724990869911a715c03ac64b6f618d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b82125bd4890eda63997154ed85ccc314724990869911a715c03ac64b6f618d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9f4fb69c7a44de762fdf13f87acca1ddd19ca04283977b0ec6e0955b52384c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdeba329c631cf922db7f535932b772cd2e5e658c0ed2f9eb67a4dda91cb6930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c111782ea20ed895fc5b6bb5ff6a3ae8e9c5a1a2b093fcfc2d18a8bc7bf4893"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jf")
    bin.install_symlink "jf" => "jfrog"

    generate_completions_from_executable(bin/"jf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jf -v")
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
    with_env(JFROG_CLI_REPORT_USAGE: "false", CI: "true") do
      assert_match "build name must be provided in order to generate build-info",
        shell_output("#{bin}/jf rt bp --dry-run --url=http://127.0.0.1 2>&1", 1)
    end
  end
end
