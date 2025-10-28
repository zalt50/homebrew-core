class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.12.0.tgz"
  sha256 "0768abeb45ec219d78a296a8f721f6d70b50ebeaedff2d2ebdf94cf40b875756"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d76a890b324db09de9e4aca1f060cb99e69cb866b6859e9a4bd64ae43649e313"
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
