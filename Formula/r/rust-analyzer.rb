class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-lang/rust-analyzer.git",
      tag:      "2026-08-17.4",
      revision: "bb3bbbd9e4529cbf1a6392d5953f03eb01af3792"
  version "2026-08-17.4"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ee8261d6b4461aa23f56bb8907c7cbd342cfe49c0ddeb7b053cb5d1dcfc7fe9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93eb8e9490aa588ef8255fe356be1e1d590c589d7ac3a1a05233bd3a4b491393"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b540944c59d704e7a9c8ff725ac0a413c7415f2d6cf42481c634c75ea6d47838"
    sha256 cellar: :any_skip_relocation, sonoma:        "5aaac021571657cd49448b99476cac1dce67b51928483c769ca0166055347ca7"
    sha256 cellar: :any,                 arm64_linux:   "2db692642ba4349dc26d27ff1f88fae14a972e45c34a4753a35b2a329a6e8667"
    sha256 cellar: :any,                 x86_64_linux:  "f09ea832418f3f7add0dfdff376bccb1a292c97840ac493f4bf3b3c242097621"
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
