class PhpantomLsp < Formula
  desc "Fast PHP language server written in Rust"
  homepage "https://github.com/PHPantom-dev/phpantom_lsp"
  url "https://github.com/PHPantom-dev/phpantom_lsp/archive/refs/tags/0.10.0.tar.gz"
  sha256 "20db6d1a0e709ada6beee420323c979a5245ba1949c88824f1cc4d624b31bec7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85174bfb904c97afc703234db413d09a63a57de063d4b6e95d5b1c454706a05e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4233850eea2b53b812f72d59be4321ab29907421fc449072481e448c6a96dfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91fbb93ebb3cb3a1e3629561c66c102567862ffa003050db77077f6da64031e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd8e590ac580a9b26fae8a5f3e96eb689f3757e2f01ee49065205e128335960e"
    sha256 cellar: :any,                 arm64_linux:   "f202565de7d72d3004326c17d779c20bc8160a3ea0fafcc194050d79a96a2da1"
    sha256 cellar: :any,                 x86_64_linux:  "7264097b7be36c91d9bd7d16759b06c7eff17770cc40e738b0bb2fb56aac97dd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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
    output = pipe_output("#{bin}/phpantom_lsp --stdio 2>&1", input, 0)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
