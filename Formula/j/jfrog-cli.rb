class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://docs.jfrog.com/integrations/docs/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/2.110.0.tar.gz"
  sha256 "44819c890840cd257a58d5f9cffad23f631b22810a6007afba1843a0b4b14112"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1108ee15eebb6d7b70b289703bcc1a493aee2124023e5c9d0b4db805c0647dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1108ee15eebb6d7b70b289703bcc1a493aee2124023e5c9d0b4db805c0647dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1108ee15eebb6d7b70b289703bcc1a493aee2124023e5c9d0b4db805c0647dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c520311e3f841d47ba15c31996f223277594a612cf0676679cc86d6bf81f265d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5d4c017df4f43659d05b915fefb39d70859dcaf8fdbd71d9eaddc3e1f2a65f4"
    sha256 cellar: :any,                 x86_64_linux:  "b61485afd5fa3fc2416aecdfc55047ecf237459594b5f3e30856cfb08a05e67b"
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
