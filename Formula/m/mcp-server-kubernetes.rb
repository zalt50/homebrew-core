class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.1.8.tgz"
  sha256 "8d26166fe71dfe544cf8120e63c90b0430c2aead81dd67913527b5cdea13b252"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "951846b80dddbe26c94cf0c414bd27550b09b267d46dc45ac67244bd077b311a"
    sha256 cellar: :any, arm64_tahoe:       "951846b80dddbe26c94cf0c414bd27550b09b267d46dc45ac67244bd077b311a"
    sha256 cellar: :any, arm64_sequoia:     "951846b80dddbe26c94cf0c414bd27550b09b267d46dc45ac67244bd077b311a"
    sha256 cellar: :any, arm64_linux:       "077697866c32d6f7a4b6c3a82abaefb6a07e73b9da4e881d7e0d9101d0f2df7a"
    sha256 cellar: :any, x86_64_linux:      "8ce548326f3a4d20454e37258537d6d420f045d7dd602456011d005c6cfedbea"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/mcp-server-kubernetes/node_modules"
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON
    output = pipe_output(bin/"mcp-server-kubernetes", json, 0)
    assert_match "kubectl_get", output
    assert_match "kubectl_describe", output
    assert_match "kubectl_logs", output
  end
end
