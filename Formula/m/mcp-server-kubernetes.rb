class McpServerKubernetes < Formula
  desc "MCP Server for kubernetes management commands"
  homepage "https://github.com/Flux159/mcp-server-kubernetes"
  url "https://registry.npmjs.org/mcp-server-kubernetes/-/mcp-server-kubernetes-4.0.6.tgz"
  sha256 "929c660bb1faf46a5034d02a7603f42f2ad3b09a72f850597bd51c8e6be2d527"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "48c24d83824290921910fd7e236f0dd384c929e55ebd2cb2fee6d5dc4e4ea817"
    sha256 cellar: :any, arm64_sequoia: "48c24d83824290921910fd7e236f0dd384c929e55ebd2cb2fee6d5dc4e4ea817"
    sha256 cellar: :any, arm64_sonoma:  "48c24d83824290921910fd7e236f0dd384c929e55ebd2cb2fee6d5dc4e4ea817"
    sha256 cellar: :any, sonoma:        "068ee45ae1dbd8d8ccffed4379facba0a3d0691d691560b613845ec33bd99c0f"
    sha256 cellar: :any, arm64_linux:   "91f16ddbb8e4e1141b0ac1adbbc9390e702688303a860efbb0cb8bce1d1bfb32"
    sha256 cellar: :any, x86_64_linux:  "60c07bdd24e7e29e174349312fd530d8ec1d827ee09e2ef48656c030a778fe24"
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
