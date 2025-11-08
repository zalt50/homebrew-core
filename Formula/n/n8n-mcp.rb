class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.22.13.tgz"
  sha256 "f08bdc7c3cbdd19ce633c3c3d596034b928fbb961768c2b5ea6577baf13ed6fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "351e6fade3e956aba93ac7ff26df8c1092466d1f91257e13f7861e8797eca6a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "150d83ed36ab3e8e44b424f826e9692ef5e1a73400d727bc71516affa8d9b95e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c3a5942c0e9effcb6ec587d434941e7a6783586b852e82ffe49a71e9930af1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c14b647b53b7d6141102092eab611c8e7e667163151b4b0e91c2d2aabd57e592"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16b7f1a82519bca8f8285f51c28570b09fd7440f6db59f11872d29d528c371e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6663d2997bac7251cc7f66ef7e67c1c041e6dbb5cea0115649f9f72947cd84f5"
  end

  depends_on "node@22"

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
