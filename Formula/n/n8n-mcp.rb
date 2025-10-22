class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.20.8.tgz"
  sha256 "f0e0eaaf84999e71155d0fc33b63bd7129f6d1354af1119624aa47517781c991"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b76a9f56a5c44c5d47963c55359a8001aba31a7d0df5f9c8feddbac34e94773"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90eb5f7a54d29bc3b4bc0708afe9ccb7837c47ba450962d1ca850407c7ed5b86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e069eace616cf29602801901b5801125a42ee74919263a717d8ebbc2eb0d00c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3b1f406960b8613bafbd542f989009c17c7fa7c8eec9bdda398d01a14dae234"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8f3c0898bb0aa3f0a18591b12c1b7459556dae9aeae6c3c91d0f1ecd0fd0e3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7403731a52076360e497213c5bad1899b7fbf78cbde1dd9a549502eb189f2ca"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["N8N_API_URL"] = "https://your-n8n-instance.com"
    ENV["N8N_API_KEY"] = "your-api-key"

    output_log = testpath/"output.log"
    pid = spawn bin/"n8n-mcp", testpath, [:out, :err] => output_log.to_s
    sleep 10
    sleep 5 if OS.mac? && Hardware::CPU.intel?
    assert_match "n8n Documentation MCP Server running on stdio transport", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
