class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-08-10.1",
      revision: "f938641be53c2e4bacd7dc46bddb74825a3e9d28"
  version "2026-08-10.1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5d5efeee793859e01bcfc365ae50e0ee51a6408773c8a9c3a21846f77a198fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a00528baaa7b058cbe63f2f839167c993a4e57ca1dc6e0df40316f12ae3e816"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa7d34f6e7027e21d6834a904cc29834983b6e1951551db6de9e915187dd696c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cbf25634d0113eebc797a39ea9f6e07bf8b672aefff876f1148a92eb715ba77"
    sha256 cellar: :any,                 arm64_linux:   "d1cf592eb6c8360b0f3243c318f58b8e9b2546623fe3f763ca08fb27e276d254"
    sha256 cellar: :any,                 x86_64_linux:  "775ca2f58f526e6208d9004f993c18004f1987f921ae3a307b580e14a25c900e"
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  def rpc(json)
    "Content-Length: #{json.size}\r\n" \
      "\r\n" \
      "#{json}"
  end

  test do
    input = rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id":1,
        "method":"initialize",
        "params": {
          "rootUri": "file:/dev/null",
          "capabilities": {}
        }
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"initialized",
        "params": {}
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "id": 1,
        "method":"shutdown",
        "params": null
      }
    JSON

    input += rpc <<~JSON
      {
        "jsonrpc":"2.0",
        "method":"exit",
        "params": {}
      }
    JSON

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output(bin/"rust-analyzer", input, 0)
  end
end
