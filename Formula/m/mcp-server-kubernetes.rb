class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.0.8.tgz"
  sha256 "3fcdc4edd060a854fc3986b63c4ff72cdc37af751deee9db0c03a87a0549c917"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d92f09d1655692edbd8a56f0cba1948b5ae1fc9a810d6729842dc7296d39bd4a"
    sha256 cellar: :any, arm64_sequoia: "d92f09d1655692edbd8a56f0cba1948b5ae1fc9a810d6729842dc7296d39bd4a"
    sha256 cellar: :any, arm64_sonoma:  "d92f09d1655692edbd8a56f0cba1948b5ae1fc9a810d6729842dc7296d39bd4a"
    sha256 cellar: :any, sonoma:        "2cd71f47dc90941c5c2601e674acf6d90beab48f77f32ac83e272d35f309b47d"
    sha256 cellar: :any, arm64_linux:   "cdc1b84c66ddd74ee71c5e0837cb30979ce3e6bbce9f2ceb11446f6500f2a6b6"
    sha256 cellar: :any, x86_64_linux:  "c36d53157847a1d83798864095dc51e29ffaf58b0a301f6931dc9deb8c8468e5"
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
