class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.0.0.tgz"
  sha256 "ea664d263282c18765247ee54034093a7d171996ac022a221026df428eb17b8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "115892d1b7a7e402354d453644c430659717540226093ea7a0b6efcd9c08bdd4"
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
