class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.12.0.tgz"
  sha256 "01eed38748863f8a64fc7f0c30e6e1835d6f7d675c368dd4d7ca9d14398ca8e3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b339aef9f991d0e8e3de8a66f6a05c946fc24b2bb6b9b437d08a84b4d2d5712"
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
