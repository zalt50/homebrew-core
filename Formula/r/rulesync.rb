class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-4.3.1.tgz"
  sha256 "26065c924ab433d9e6f93452c4b7c0228e8f6cac44f85b5821723370e0e1e2fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0195a21d93c416e341ed9eabf732f3a08380e7ac057c4c3c66a8c6b99550a1f1"
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
