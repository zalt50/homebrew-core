class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.2.0.tgz"
  sha256 "b5fac945997df2328a5e1f30c1590a77a2954e97f7a470e70991ebfcdb1b5246"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b1ae1ffbb35e8f82a4393f9d6cad243c979d834e42d0ea6f34bfe90ef1fb25ac"
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
