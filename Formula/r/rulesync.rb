class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.14.0.tgz"
  sha256 "6c3851e8d2f74fba90aa68d0219fe3159f74ceac452f72621e656c99ef1e2947"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3b2a5b89c675865abd8f661841825631318fe4eeb69841031173402d0afbc83d"
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
