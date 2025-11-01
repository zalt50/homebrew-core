class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.12.5.tgz"
  sha256 "bdb8c41d9cf7b00aaf5a6c041dd0ed33abbbae21de1508af90aec3a340ea3280"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6fa05bba4bdd270bc9bd6c9388a3726484be4c0290981fcc34c0d921055d918d"
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
