class TsQueryLs < Formula
  desc "LSP implementation for Tree-sitter's query files"
  homepage "https://github.com/ribru17/ts_query_ls"
  url "https://github.com/ribru17/ts_query_ls/archive/refs/tags/v3.15.1.tar.gz"
  sha256 "88f191fbc4665aea8d8faa67f650ec07a7dd83eecf2e6bc04b87891e64a4e6d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "288687ce1a1c71fa37e149a9b4178d7fb7379a60f472559aec624d1ad9342d45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5a7e3e6eb885174275a45a96618261940092166e5871d5ca75d24582da16ecd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b97d0c19c6b7b0c3ef9c68c0ec8b052241e9ed7875d05bbaeab340532696925e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1461ea591924258d07c9bf8c34bcaa04551170c9521493c97eb91e0ea61ff26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3aa5b6b417b27b2c8e81f7c05fafed40abb95b918939f9dd71669e2477f321e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97f47d251050ac4c0881216fbcbfa275df5a5be6f807c1fa2575f94a7b7dab3d"
  end

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
