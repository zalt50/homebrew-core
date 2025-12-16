class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-0.18.0.tgz"
  sha256 "8a287a136d1c3ca8c2a685a8aa5da83d5f2e739bc31ade48e2d2a0a3a92292a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c5743d861c3d74911624e967b885e5d93265aae24107a04dde1461f984e27f64"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port
    ENV["CLIENT_PORT"] = port.to_s

    read, write = IO.pipe
    fork do
      exec bin/"mcp-inspector", out: write
    end
    sleep 3

    assert_match "Starting MCP inspector...", read.gets
  end
end
