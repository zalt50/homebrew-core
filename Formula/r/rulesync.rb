class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.17.0.tgz"
  sha256 "5c5177c051a8399798248f78e72a8a9c73d5307f6da5cbfccc04a2a373d681dd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0dd89edd4d12a9c50139eca0af178542f9c39ba0d02dbc270e575bdb0c9db51f"
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
