class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.12.1.tgz"
  sha256 "4c2e07bfeb6a1411ca7e15f3d80201ed1d19d257f1dcdc8ffefad46759267d88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "507762811be5d0512bb9f69ccae06bb118ac5339d94820f9ee71129b7bffea92"
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
