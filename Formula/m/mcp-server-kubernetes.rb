class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.0.4.tgz"
  sha256 "4089393c53445d0e0cdc5463224d31b86b4a4059b7cf34ee2c1fa130c9b46d17"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d5a0499945fc7babe5a8f6808fe27890556decde404005acdcb0829023123db1"
    sha256 cellar: :any, arm64_sequoia: "d5a0499945fc7babe5a8f6808fe27890556decde404005acdcb0829023123db1"
    sha256 cellar: :any, arm64_sonoma:  "d5a0499945fc7babe5a8f6808fe27890556decde404005acdcb0829023123db1"
    sha256 cellar: :any, sonoma:        "f25905364c174e0da78a4ed1e141e12d0f7be00cd531fed8a8786841edc11807"
    sha256 cellar: :any, arm64_linux:   "99f01cdcef96d1dfc84c3744a4125753cf3b7623e10441f7a1ed546702a1b013"
    sha256 cellar: :any, x86_64_linux:  "22b733e214c966ce5a0c228abf891d5fac05df463da97652635840be2e501d7f"
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
