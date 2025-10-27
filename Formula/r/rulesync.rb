class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.11.3.tgz"
  sha256 "22232f686992708071d1a389d8445b778aa72f987a5ca2abe82c0a3d83d66bab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7996df45d8793223ad4f5ebc68094ee4e7652928402d0ff0741264185c6859de"
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
