class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-5.2.1.tgz"
  sha256 "b1111bcb279bf3e140631bf36fcea59cc0ecff7dc2a264fe200be21baf0cd4f9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ef82ae5404fe46b5da42bfae7020175d7fc55898c131888f148aa637c473914e"
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
