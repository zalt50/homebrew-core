class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.22.0.tgz"
  sha256 "9769edd29ab10d786c73ddc2c7bcf53ea86d06e1bbb59b300270b9501c2ff3de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8f6572c0d64a5b259f88a2d49128cc545a51c506a59629be9499e6da7a72c971"
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
