class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.13.0.tgz"
  sha256 "3621fee13a439b7fc14adb09865d808e92c6d7da8e9039fa6a20eb11335dfc96"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4776b13f6055671f7762894eb238bd0e0060186b4ec241517f1d3da16e686bf1"
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
