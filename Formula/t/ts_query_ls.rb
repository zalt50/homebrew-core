class TsQueryLs < Formula
  desc "LSP implementation for Tree-sitter's query files"
  homepage "https://github.com/ribru17/ts_query_ls"
  url "https://github.com/ribru17/ts_query_ls/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "65ec3634b29102cddef7f53615c266bae2c2f18690b08aac814e7f317fc1167e"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input = <<~JSON
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

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output(bin/"ts_query_ls", input, 0)
  end
end
