class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.68.2.tgz"
  sha256 "69f43206f012fddcb71733995296c694baf256d64645a7ae10138bb85add82aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98359afdb9ce4f42210db1f72f17b33950b46f6f9a7c8598d2fb24baae431914"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98359afdb9ce4f42210db1f72f17b33950b46f6f9a7c8598d2fb24baae431914"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98359afdb9ce4f42210db1f72f17b33950b46f6f9a7c8598d2fb24baae431914"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8e5b96276d53f6ec94cf8b20095407205e624ead91c6379c8139f20ca4f8ef5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98359afdb9ce4f42210db1f72f17b33950b46f6f9a7c8598d2fb24baae431914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98359afdb9ce4f42210db1f72f17b33950b46f6f9a7c8598d2fb24baae431914"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = [
      %Q({"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}),
      '{"jsonrpc":"2.0","method":"notifications/initialized","params":{}}',
      '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}',
    ].join("\n") + "\n"

    output = pipe_output(bin/"n8n-mcp", json, 0)
    assert_match "\"name\":\"n8n-documentation-mcp\"", output
    assert_match "\"name\":\"search_nodes\"", output
  end
end
