class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.31.0.tgz"
  sha256 "729c833c16fc165179c2a7a6f155bbf73f6ed67898bb670702dc3dab78966a49"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "593b7bca365e303c3f32742d80a25930490c77ba46acabe4d74862bf63097f09"
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
