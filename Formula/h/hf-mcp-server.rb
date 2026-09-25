class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.21.tgz"
  sha256 "80e965aa74980743ccf8bae9c0f1873fab16c9ef6518d413a10d2b4a606f121c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8b4c4aaea2d9cf104a74bf215bc6fb51b10fe46bef1cb08a424b956e7e6158e6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8b4c4aaea2d9cf104a74bf215bc6fb51b10fe46bef1cb08a424b956e7e6158e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8b4c4aaea2d9cf104a74bf215bc6fb51b10fe46bef1cb08a424b956e7e6158e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d082ec36454c731f28e020f88c7ebf8e548a37b4568cc3b0d3c35ab384843be1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d082ec36454c731f28e020f88c7ebf8e548a37b4568cc3b0d3c35ab384843be1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@llmindset/hf-mcp-server/node_modules"
    # Remove incompatible and unneeded Bun binaries.
    rm_r(node_modules.glob("@oven/bun-*"))
    # Remove dev-mode-only bundler and CSS-toolchain prebuilts.
    prebuilts = %w[
      @rollup/rollup
      @rolldown/binding
      @tailwindcss/oxide
      lightningcss
      vite/node_modules/lightningcss
    ]
    rm_r(node_modules.glob("{#{prebuilts.join(",")}}-*"))

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["TRANSPORT"] = "stdio"
    ENV["DEFAULT_HF_TOKEN"] = "hf_testtoken"

    output_log = testpath/"output.log"
    pid = spawn bin/"hf-mcp-server", [:out, :err] => output_log.to_s
    # The first `node` launch on macOS CI VMs can spend 20+ seconds in dyld
    90.times do
      break if output_log.read.include?("Failed to authenticate with Hugging Face API")

      sleep 1
    end
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
