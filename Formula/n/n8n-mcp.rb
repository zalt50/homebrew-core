class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.21.1.tgz"
  sha256 "2d27c95b1aab6e35e99bc9b61ba061b0e488307575fc4f15cd0f679094689ca1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1219c70fa50a5b9f7a44752ea164267b057f717d8fe63a3c500c8b4ab5e1026"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0031ad67221513225a4d9ad72ade5d05b0b03e8a013eef3fe977c6af842ce92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2803b77fe5d410680c3678789d713ca48b19c659817cdd1c70b35eeb1406562"
    sha256 cellar: :any_skip_relocation, sonoma:        "e82d086feaa32ae16db7062802b3040b2ae8681e0c4011c37b09fbf7bc02b288"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "654629aaebe1c4951d86b6842445f46b233c8823911f946a7459bc0bf1edba02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "716ebad9b1215bf11903f47cab284165baa3291219665af82a0bde99de705404"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["N8N_API_URL"] = "https://your-n8n-instance.com"
    ENV["N8N_API_KEY"] = "your-api-key"

    output_log = testpath/"output.log"
    pid = spawn bin/"n8n-mcp", testpath, [:out, :err] => output_log.to_s
    sleep 10
    sleep 5 if OS.mac? && Hardware::CPU.intel?
    assert_match "n8n Documentation MCP Server running on stdio transport", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
