class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://github.com/musistudio/claude-code-router"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-1.0.68.tgz"
  sha256 "b9543a8d410f8649b2d66f006f46c9045562b269c6c5743238413551fa7797a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1e2c32061623297add7435089a0c5b19b7e428a2c8450d133a870db43eb0b033"
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
