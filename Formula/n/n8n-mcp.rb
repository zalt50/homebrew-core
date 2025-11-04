class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.22.9.tgz"
  sha256 "522eb0efd0babc6aa9503d43d2b748436a90c144368e9d5edc31fae366196b12"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f399d083d5d7b5b8763c6cd7244836aaa6ee81d2727f6efaa0d6f942468b0ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed05c4aefbcea2296b130e676928a5779dc4cf3bc78d86d9db889731c019d130"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05877dfe6c526c260b9ed026118fb4a28710b47b17d2f996db68bb231f0a9747"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad7928ba9c219bd916e9e27e8fd48991a6ecfe1e5395eae36404c90143e644e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f51133fa880c2c6f7fa4db2f852e08311adf53f27aa342f2842247ba22bab87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb6578804fe42c2e6468c99cf7b8f4a1dba86f42c653579e1aef5b84e3074a01"
  end

  depends_on "node@22"

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
