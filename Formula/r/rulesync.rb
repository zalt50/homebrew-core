class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.12.8.tgz"
  sha256 "f9cc348b5821361ea5138245df0bd0100151f37e3863cded35f72b6e9efe2f0f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "958f5bd72481b1e0b0e4004e7e1827046835301507c94e51e6df81f4e28a303f"
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
