class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-1.0.0.tgz"
  sha256 "02684b5238eba62bf64cdd5cf3e9feb5d04a2feabf557c423a8298eb76ba66ea"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e611d3212a6e67d8219d63727473f35af1f1630aa28c2254b07712794f60ccbf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    node_modules = libexec/"lib/node_modules/@modelcontextprotocol/inspector/node_modules"
    # Remove incompatible and unneeded prebuilt binaries.
    rm_r(node_modules.glob("@oven/bun-*"))
    rm_r(node_modules.glob("@rollup/rollup-*"))
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
