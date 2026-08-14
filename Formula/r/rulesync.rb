class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.12.0.tgz"
  sha256 "8510c005452485ca428002eab8732e85add26be9b31625639bc47ee039d55d54"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "984f0bfe7d3ab72f547fdbdb30731cb521977c3bcb4f00dcb63c86e4848301b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "984f0bfe7d3ab72f547fdbdb30731cb521977c3bcb4f00dcb63c86e4848301b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "984f0bfe7d3ab72f547fdbdb30731cb521977c3bcb4f00dcb63c86e4848301b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "87e0968d961e90724270e3d4a567c10e6629e624a9fe9735bb21e962887ae9ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87e0968d961e90724270e3d4a567c10e6629e624a9fe9735bb21e962887ae9ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87e0968d961e90724270e3d4a567c10e6629e624a9fe9735bb21e962887ae9ff"
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
