class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.25.tgz"
  sha256 "74af0169847616569ab32fd3e6274ae98388d8c7fcdb89abf87a6bc88263847f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8ae78a6b315f7c01cfb18de577e3348c72b3da01d2fa4ebcf925afa5b9331480"
    sha256 cellar: :any,                 arm64_sequoia: "6f4bc20c80351cd43d028e6969f223cf6e3ba7c0e61d329599401011dec0696e"
    sha256 cellar: :any,                 arm64_sonoma:  "6f4bc20c80351cd43d028e6969f223cf6e3ba7c0e61d329599401011dec0696e"
    sha256 cellar: :any,                 sonoma:        "491ff35e51e200fc327c7772380cd80cef6986a4f23b31e0bc1cf19e017d56a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8072993a393e04503fd91409987010f7458109f1744769c600c12680493535f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3a921e03715c3828b81569614d3b44e8c5739bd3f9e30b20a8da86617cec2b5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@llmindset/hf-mcp-server/node_modules"
    # Remove incompatible and unneeded Bun binaries.
    rm_r(node_modules.glob("@oven/bun-*"))
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["TRANSPORT"] = "stdio"
    ENV["DEFAULT_HF_TOKEN"] = "hf_testtoken"

    output_log = testpath/"output.log"
    pid = spawn bin/"hf-mcp-server", [:out, :err] => output_log.to_s
    sleep 10
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
