class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.11.0.tgz"
  sha256 "8968d63a2a02e8593bb91ee625324cda5a8696fbde378ee0f8e1c0f045b0890b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "93ce044db45b1c5337c22b73dc2c65a87e065fbf6ce1526eb522da12334a6c0b"
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
