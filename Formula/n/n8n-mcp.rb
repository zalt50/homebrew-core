class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.20.6.tgz"
  sha256 "15b2482f513d7c6465857b30551fc7d43299b1dae89f302f2c1004acefb1e3e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27ae45ef39638937cb431816bfd8a336de305c6554a230e87e83e7ab277f648b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "480d075a77b19800a932bf51c8aa6bcc4690b3d6b573f68bc9ea299c2e09c280"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a144dc8367a9b9527997b9a6f7303d51ed758298e313743e21563c32f52d545"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1789288dfd78d75aec93a2823f849ed6590651d102d9e009d6d885ca8bb5373"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5279309acd511a3b598ca579d6d888b702d59593beca3451628d5cab48983937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65513b722c6d20e747466cea4b5e79b53ec36775d88f84d9b68a99c3cd52c93a"
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
