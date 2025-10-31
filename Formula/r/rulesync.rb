class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.12.4.tgz"
  sha256 "41b75f2166215a2cd297e5c55a866030b6e44c8184009b0e0e85abbb3621b821"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "929df1144499c0cc5b9dce9a3df3963f154d7b00844552a6bd7f3e37573ccb6e"
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
