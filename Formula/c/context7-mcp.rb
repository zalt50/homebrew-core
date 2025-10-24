class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://github.com/upstash/context7"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-1.0.26.tgz"
  sha256 "4d4be0443718ab0ff8ad9a1e172e8c5f01f0c77f4f00d8477e4baa4375113945"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ec4cc4304003d8b970ac4949156f2ffd4b3c4e8c303bdbdd9e8226bf3cf16f1c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON
    output = pipe_output(bin/"context7-mcp", json, 0)
    assert_match "resolve-library-id", output
    assert_match "get-library-docs", output
  end
end
