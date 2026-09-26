class Gnhf < Formula
  desc "Autonomous agent orchestrator for long-running coding tasks"
  homepage "https://github.com/kunchenguid/gnhf"
  url "https://registry.npmjs.org/gnhf/-/gnhf-0.1.50.tgz"
  sha256 "77301729c7d0b01acc4b7a09dc9878b1f211ce60c0f259513bbed713cc37a370"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4b314177734a2ca34ff23a6332de69380cbb9c7f2df3afb16c4daa0e3b397f9b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gnhf --version")

    output = shell_output("#{bin}/gnhf --current-branch 2>&1", 1)
    assert_match "gnhf: This command must be run inside a Git repository", output
  end
end
