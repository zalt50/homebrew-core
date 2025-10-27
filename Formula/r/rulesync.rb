class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.11.4.tgz"
  sha256 "9c390e67f221ded8cacc07d456ca39157f25c1020e1d293fd8bc93ed1e16aa03"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "10cb39a493f9d9c08357adfa7b7f505352309960d2aab80e6dcff65a3ef4ea36"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
