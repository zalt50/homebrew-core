class PlaywrightMcp < Formula
  desc "MCP server for Playwright"
  homepage "https://github.com/microsoft/playwright-mcp"
  url "https://registry.npmjs.org/@playwright/mcp/-/mcp-0.0.83.tgz"
  sha256 "f0014a13361b1ee2d8607a4e187868ab9a6e8ac637dbcd66e4af43f738d0c8cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "87edcf60e8840935266c9edb1d6c09c6ff34b3f0d8d1efaddcbb5e19a7391a5e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/playwright-mcp --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}
    JSON

    assert_match "browser_close", pipe_output(bin/"playwright-mcp", json, 0)
  end
end
