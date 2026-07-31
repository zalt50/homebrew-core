class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.4.tgz"
  sha256 "5140b7e3ae6d96be6cddb2450bd37e1e45ca285a1f9936f94873b0569463aadc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1842bcb6fc12728eb0ab0b0de0742abfba594e1ed258be4c12fa2a511beb4de9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1842bcb6fc12728eb0ab0b0de0742abfba594e1ed258be4c12fa2a511beb4de9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1842bcb6fc12728eb0ab0b0de0742abfba594e1ed258be4c12fa2a511beb4de9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2df43becc1a0bc969dfe4b0f3bad41ba8196cb1099199116cfdea71530dc682"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec403bce6b6c603d6a9462b2f0817a6b873d90d5040639e32e05f16855fac996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec403bce6b6c603d6a9462b2f0817a6b873d90d5040639e32e05f16855fac996"
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
    sleep 15 if OS.mac? && Hardware::CPU.intel?
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
