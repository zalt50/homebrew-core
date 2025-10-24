class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.11.2.tgz"
  sha256 "53807a6771813174132e1ba3f3f6390725defc4e76e0a2ca581815e5b14bb409"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "87f4e1926976691f484bc9e0b4ec3a4062961f37f34c82691a8cb104a986d278"
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
