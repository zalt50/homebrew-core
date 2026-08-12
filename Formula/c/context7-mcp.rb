class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://context7.com"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-4.0.1.tgz"
  sha256 "92e97eb3a7fb7807a64f00ff30053c831bd67f2230f4fa9c6a2b9dabad8217c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0765d3fbfb6f306191ee25609c74cac1a7cd6bf2b37a19e0394d01fa630c1602"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON
    output = pipe_output(bin/"context7-mcp", json, 0)
    assert_match "resolve-library-id", output
  end
end
