class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://github.com/musistudio/claude-code-router"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-1.0.71.tgz"
  sha256 "30ea7716eced041e570f1144cdee728cc01db10ba8d275cad6f807756dce4821"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "36bf0ea14f34034f67767d9b0c9ee6aaed71808d76b2ed3541d633f15a243b43"
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
