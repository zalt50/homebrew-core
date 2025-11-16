class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://github.com/musistudio/claude-code-router"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-1.0.67.tgz"
  sha256 "9c47182ecd127c0367fb6fd8774bfdd3b073d1715933188d52cbf15f6e2f24c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9eb96f18684f0b6dad891c19251eace356fb214ef65e5c7854c6fcdf93c29187"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ccr version")
    assert_match "Status: Not Running", shell_output("#{bin}/ccr status")
  end
end
