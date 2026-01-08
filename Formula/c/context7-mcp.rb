class Context7Mcp < Formula
  desc "Up-to-date code documentation for LLMs and AI code editors"
  homepage "https://github.com/upstash/context7"
  url "https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-2.1.0.tgz"
  sha256 "5385997c1d613a55cc55bbeabda71c34a290cc95fc48e11f2b865912f00e48e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6e606a95a841eb2bc47d2b90e7809af50b37989a0bfc69d70c431aa5323ccb1e"
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
