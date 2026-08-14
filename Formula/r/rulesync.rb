class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.11.0.tgz"
  sha256 "64f0d3f788ea7f7edede35047eec26dfcd8b0eeedb339900a08a84e62d00a61d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8047147da13ed3833013a43a4d918932ea61a769ed18787a3ca53e0c2ed1b955"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8047147da13ed3833013a43a4d918932ea61a769ed18787a3ca53e0c2ed1b955"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8047147da13ed3833013a43a4d918932ea61a769ed18787a3ca53e0c2ed1b955"
    sha256 cellar: :any_skip_relocation, sonoma:        "984b958b0b165414874814c415e30fa9027ee217a44f525ff5e9c804bd88346a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "984b958b0b165414874814c415e30fa9027ee217a44f525ff5e9c804bd88346a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "984b958b0b165414874814c415e30fa9027ee217a44f525ff5e9c804bd88346a"
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
