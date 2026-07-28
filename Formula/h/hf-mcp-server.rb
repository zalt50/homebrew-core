class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.1.tgz"
  sha256 "1ba4c204a9a78e327306a5db5e886e98425cd57bcc4ec2798ed0df8172ddd74e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "101380a4ccc8db1e56f9807f548be177822df197144ad13dc3a11334bfda3cba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "101380a4ccc8db1e56f9807f548be177822df197144ad13dc3a11334bfda3cba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "101380a4ccc8db1e56f9807f548be177822df197144ad13dc3a11334bfda3cba"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfbfb330f85ed4c8fa0ffc36e8bec69164d637185e76295c2844772a0c521b81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c74fe42c9bb8f2425a26b83877d6cf259759e9d7a0933f2b52417cc5ad9aa4b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c74fe42c9bb8f2425a26b83877d6cf259759e9d7a0933f2b52417cc5ad9aa4b9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@llmindset/hf-mcp-server/node_modules"
    # Remove incompatible and unneeded Bun binaries.
    rm_r(node_modules.glob("@oven/bun-*"))
    # Remove dev-mode-only bundler and CSS-toolchain prebuilts.
    rm_r(node_modules.glob("{@rollup/rollup,@rolldown/binding,@tailwindcss/oxide,lightningcss}-*"))

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
