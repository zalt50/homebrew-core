class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.3.17.tgz"
  sha256 "4adc40693f53674ca7e0f806a0e4f558bf63cfc5b7312eb7336464ad66ee3e7a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f825be268ac42f6447635d91906fc86628c6bf83c6368bc41b2397c029d938d9"
    sha256 cellar: :any,                 arm64_sequoia: "3177aed6305c16f7b179fad7fb85e7426e12c638c8f83acdb9278be6a02cd5de"
    sha256 cellar: :any,                 arm64_sonoma:  "3177aed6305c16f7b179fad7fb85e7426e12c638c8f83acdb9278be6a02cd5de"
    sha256 cellar: :any,                 sonoma:        "766786f376230797749402acc78fc336c3c8e398bde9fa000271f94812eae226"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4fb283d47de7512a1c8b6e933747e1ddbc4343bf46a75a148b3e12def56317c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d4a3a5ec02f66f2098492a81661d941ff1c723e7ae31eae85aa5c9df6100050"
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
