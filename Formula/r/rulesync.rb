class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-13.0.0.tgz"
  sha256 "e6048f4a262c3b923f73f91b3c3229974c657e503eaf2d364f262a9f29a2cfa3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5512518d19186eb4a8465c074331e4a6e5d2417c772dc9e726ccbfcb866b5d5b"
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
