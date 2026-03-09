class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.17.0.tgz"
  sha256 "4e4c51171603b085c13b786a31834700f1ab484e90d0ec403462858ba011bb49"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "daa33e252fc8a94f7a3ed76e9d8e03bb09033d71be34bb401bd3f963c27304c5"
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
