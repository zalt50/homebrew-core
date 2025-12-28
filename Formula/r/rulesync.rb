class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-4.2.0.tgz"
  sha256 "1a43bb1d4ce435d7eefe4d312976438ca0283f5953367fdd464f649c6a09cdfb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "821b6031832f16500878d5914f71dcf03043fa81dc9c28f79d001b11dcf17153"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
