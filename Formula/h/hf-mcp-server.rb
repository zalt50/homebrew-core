class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.3.tgz"
  sha256 "33ab20f2d3101a2d53f05c45d4547e072adaca154fc224db40bed0bdd5b97c1d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0177c5647c4cdccf41837b03efef312ebe94d273e01dbaf745b33881f1ff8aee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0177c5647c4cdccf41837b03efef312ebe94d273e01dbaf745b33881f1ff8aee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0177c5647c4cdccf41837b03efef312ebe94d273e01dbaf745b33881f1ff8aee"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cbf0cd45c83e807e38c2120689fa958f944456418fde88ccebefeaf4faa82c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bafe09129321c53446df6fbc3d5841b241e0dd4ecf9c240ee235ae4096c5112f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bafe09129321c53446df6fbc3d5841b241e0dd4ecf9c240ee235ae4096c5112f"
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
    sleep 10
    sleep 10 if OS.mac? && Hardware::CPU.intel?
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
