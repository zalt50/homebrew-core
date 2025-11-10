class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.16.0.tgz"
  sha256 "be7fddfabb8d2cff57e6241c26315d35f6de9b45910c15133ad882e4b8190a00"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2875b5430450737341e8841264ae5af840f37a0ddcfa665e3ce91c9ac2f515e3"
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
