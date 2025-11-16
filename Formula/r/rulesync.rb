class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.23.0.tgz"
  sha256 "e554aa5c4d3d8872422428e59498e9968c2bc73e83dbfb32988e23ba0e37ec7c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2a86469bc448f418f879c28eb42f62a7a0911f9e6ce8f8f93e0e9826226791ba"
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
