class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.20.1.tgz"
  sha256 "7669193e3bdb6e3ed7317b9810477fe078b3cf03929dcc20a89ff9588cb6add0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa18fdfecca2d1685e331987ee925e2cf802522295c718a7349a6b3b7cc630ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9be8202edfbffda128a32e8af9cc5754c04ffbd15882b89638adc148ec124e6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6118b763c2b756049626724ca11ac5c6e06c15868a69fa326ca62781b2a5b767"
    sha256 cellar: :any_skip_relocation, sonoma:        "742ac8a4f1daa85ad61bc58c7e7c023ca8f6822f305cdf375304bfef352a95a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adc435be047c3de0ba759cea79bba3cb57ed96204a3c1306ce22a90403b46230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7a258415a8ea8d3eec16a463655f9ba51f540bc1fb9393c410f34db6ae23e6f"
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
