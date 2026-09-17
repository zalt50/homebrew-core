class BashLanguageServer < Formula
  desc "Language Server for Bash"
  homepage "https://github.com/bash-lsp/bash-language-server"
  url "https://registry.npmjs.org/bash-language-server/-/bash-language-server-5.7.1.tgz"
  sha256 "df4b9e558463774a217fa41426db67ce92fb7e6a96f1a9a029c002778f2866b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2b06ccfcd0b9ae085cb48f9cc5cf41b38959b4ac4b48791b168dc76fc8d4f76a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/bash-language-server start", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
