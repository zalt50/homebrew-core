class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.21.1.tgz"
  sha256 "b0707a7c097d276cef52781ee95587dbf0777f2db83f6a3f5d00f5deb2cd1f07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cf9094f3ae502e93d34e38bc02b95fbe12a7d0b80a3e57df36a715cab9b3719f"
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
