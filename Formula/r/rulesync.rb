class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.10.0.tgz"
  sha256 "3c4fe993b209402d97d413d225b80286c6c6b8e5e52d83f8448410520b5ba6c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "24af6ffca62250a0b47614af9bf168af9af83d5e912e6229948d0aa2690d2b30"
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
