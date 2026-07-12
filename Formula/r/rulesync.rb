class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-9.6.3.tgz"
  sha256 "470aebefaae4b74c6a31b509c10287b1863293690ab4bd74cf9597e1a5dbeddc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ee410f81648f249f465b52b3007ec652cd8f300236e6ca2ac0a5f42f3c12b526"
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
