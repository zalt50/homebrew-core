class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.22.5.tgz"
  sha256 "bc0e215e45d258244bd7af1c57b051a8caed17258047f2a9361cfdc766305f6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3fa6d9c9b95413b035aacfd6e2482767229afea277a88e47f2d093f107f6e8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d113698c033e21fa89da247c155cfac1505d5a857460283f446bd8d692decd84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22684e363930ae1c638610a722ecb12ab0e288e054162ff19cb8553801ecc297"
    sha256 cellar: :any_skip_relocation, sonoma:        "06f5e4fed6e048e4d16847c852058284210052418442ee49142fb045b3457ae3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b1f5766061eda1f2d801be5a4e60b23147bfa1983e02c01d1804070b34d61ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2763634b97c53987a49cfda1ca2f2ea88f6ba828e328eece15d48d005a2cac63"
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
