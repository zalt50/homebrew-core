class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-9.3.0.tgz"
  sha256 "29a2ae97f294b6d92b009de627eb887636760789c03f7b84ed9f4296d13c002e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f4403c6c5c1ebefaaf758045cb802114331e29e8dc80f8b6ff29a50ba4f39325"
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
