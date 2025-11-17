class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://github.com/upstash/context7"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-1.0.29.tgz"
  sha256 "f3dc5bad5c52195b5cca9c6d99189f13781ec07a61e3f8403442a03cae39fdf5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b5aff243762f0593caee211ec5395cf5d3a4c241d5b24aa93548e85c81be2388"
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
