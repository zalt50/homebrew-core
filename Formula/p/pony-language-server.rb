class PonyLanguageServer < Formula
  desc "Language server for Pony"
  homepage "https://github.com/ponylang/pony-language-server"
  url "https://github.com/ponylang/pony-language-server/archive/refs/tags/0.2.2.tar.gz"
  sha256 "80697b23d7aa8e98a474e4aa6cb552c59171217ab0fa400c9f912fa8a08d0cae"
  license "MIT"
  head "https://github.com/ponylang/pony-language-server.git", branch: "main"

  depends_on "corral" => :build
  depends_on "ponyc" => :build

  def install
    system "make", "language_server"
    bin.install "build/release/pony-lsp"
  end

  test do
    require "open3"

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

    Open3.popen3(bin/"pony-lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
