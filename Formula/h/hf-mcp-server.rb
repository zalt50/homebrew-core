class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.28.tgz"
  sha256 "cd8143c32c0cc7e24879ce9c6273b04d120ae5ef6ae996dbbbf5fdc369db3dfa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a2f9bcfaa1f16757d34c8909453148dabb9e8a179c0305fed79c80ccba614340"
    sha256 cellar: :any,                 arm64_sequoia: "9b21e4089ee23915cd10c51bb689aed232a3bca342a24cd729ef9479d417c5cb"
    sha256 cellar: :any,                 arm64_sonoma:  "9b21e4089ee23915cd10c51bb689aed232a3bca342a24cd729ef9479d417c5cb"
    sha256 cellar: :any,                 sonoma:        "20dd4b115d5d9bb846d516a44206e0a3dbe72ed6e4192aa1f5ff191ad6e240a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d729b7f3dcd873a2c67b039fab19ca0cbce8e9b79753942d92888eaa9e5b71cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dce65ab162f4deaa71b5e8adb9065029da7c6697c2f060f5f79a186efea5cde6"
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
