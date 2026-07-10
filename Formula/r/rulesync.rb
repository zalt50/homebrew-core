class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-9.6.0.tgz"
  sha256 "b1418426fe10f5f97bb099c3a49250e2e862779d5947d245d5b11743094f52b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "16e0e357872d825ef288fc8ca4c8f2420b21a2065e60dbb9dc666f6bf7fd7b67"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
