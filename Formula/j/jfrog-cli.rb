class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/refs/tags/v2.94.0.tar.gz"
  sha256 "b48544b9975254e2318faa3d8889f8becb014524dc51a8874e6a4b9ed06959e3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "850d43d8d43390726c416bfe3fce5055922d808e002a35e9a7edd2f4e382bc5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "850d43d8d43390726c416bfe3fce5055922d808e002a35e9a7edd2f4e382bc5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "850d43d8d43390726c416bfe3fce5055922d808e002a35e9a7edd2f4e382bc5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7e177256dc0b4fd577aa9277c9c4683853ca8df178addcc13b15de3c743fcb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5af8d37747ad10982183d2cc3bd1e23c0cdef877a3670c5376b9272a70f5d749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68868616f9e6762f5d081558f4ab83f31a567fde2eb30e93e48d2df3a5133ed2"
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
