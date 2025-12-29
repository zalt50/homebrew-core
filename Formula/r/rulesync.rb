class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-4.3.2.tgz"
  sha256 "7599b057715321e8458738eea8550ac0c37b50b4c5fef174cb857b51f1260f37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "269fbe800049925e48f768e28a20abc500d6127a4323ba3d20ce2a08432fb53e"
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
