class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-2.9.9.tgz"
  sha256 "ee24ee532afcf107ebea552f123cd9eed5af2e70f15f89261e1f2b9aa40e94b7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0161e899f58b310e1763c0a19c7efbc22be09431b466a6d3d058c0d9afd1ff19"
    sha256 cellar: :any,                 arm64_sequoia: "126af5e412c836366d702ed079e94693bc5255be01dca7052446b4254b1407b1"
    sha256 cellar: :any,                 arm64_sonoma:  "126af5e412c836366d702ed079e94693bc5255be01dca7052446b4254b1407b1"
    sha256 cellar: :any,                 sonoma:        "949eae8ad7d4624e31b8d783e72699dc6e9a7940d9da05387148143c3221eadb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f1ca4100ef9776123275825c2a8a26561cebf35aae2f35516eb2e2c3dd6cd9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9d72957838f3aec71fddcacc1cab5da66ff0036ca41ea6e756592c880c9aed2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/mcp-server-kubernetes/node_modules"
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
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
