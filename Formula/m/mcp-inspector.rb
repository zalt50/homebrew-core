class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-0.17.2.tgz"
  sha256 "236e00c6edd60762f464755e663dad6b5547983cdfbe24576e8d58a015c5b93a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "331273ada3b07b76f17c755198c8fa92717277e4beaa5cafcc7aa77096a36ead"
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
