class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.17.0.tgz"
  sha256 "4e4c51171603b085c13b786a31834700f1ab484e90d0ec403462858ba011bb49"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f01f39f71d1f5fabf650d691aadec8ee204737f82273e9fb989874c159576b7b"
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
