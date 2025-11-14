class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.21.0.tgz"
  sha256 "df238bfc26d8f5d16648428c351c2728a55ba4ada9f72e63379aa9f69e5738d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b85bafa0479fc01b040050fbaaf9f7bc6a1d39f33d962e057cb549d484d7d942"
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
