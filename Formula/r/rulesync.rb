class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.8.0.tgz"
  sha256 "6a97ed3a625ac30f80d463ff14e5abb5d77393c99718dd7ee7beef223d059a45"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bb2694df3f4711fca5f67756b5840192cf080ce80f70653b07ccf222e81844e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bb2694df3f4711fca5f67756b5840192cf080ce80f70653b07ccf222e81844e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bb2694df3f4711fca5f67756b5840192cf080ce80f70653b07ccf222e81844e"
    sha256 cellar: :any_skip_relocation, sonoma:        "593aab0cf20f876571b930a14547c0063305e1c982b1cdfe31bbfd27d2d81e91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "593aab0cf20f876571b930a14547c0063305e1c982b1cdfe31bbfd27d2d81e91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "593aab0cf20f876571b930a14547c0063305e1c982b1cdfe31bbfd27d2d81e91"
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
