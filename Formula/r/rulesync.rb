class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.21.1.tgz"
  sha256 "b0707a7c097d276cef52781ee95587dbf0777f2db83f6a3f5d00f5deb2cd1f07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dbb131de8f558942a5c97a58303a61cf39fd961ad6419853f037640a579d4963"
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
