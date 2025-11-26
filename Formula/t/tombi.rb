class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "929065d6b56869ae506673ff04b7edb217b7e6e844bec6fdb454a8f96181b63d"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddb0aeb909315c6ba6fc54ef9e12acfe57949527e2a82dd411cfd6683f54b6d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25c03fdba7a445a5d709c0ee3a760397a687f25a65c65fd33778515f3402c8fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82eab769b1a844dc86a8607b388b8d7e9bc9157664508d8e5385f033e307cffb"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbef2b04688655ee1d3ee0d43db22ef9f3e35cb4b3200751ac1ef3e9ac7f391e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3edfe8dd6a8293e565d3a5d33a50ebb14c08b9259313a7bd4b8353e060a7b979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a325d6d988cbde25a59549a8b0d9848e55adf73d6175807faa4f9ac7806e423"
  end

  depends_on "rust" => :build

  def install
    ENV["TOMBI_VERSION"] = version.to_s
    system "cargo", "xtask", "set-version"
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")

    generate_completions_from_executable(bin/"tombi", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tombi --version")

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

    Open3.popen3(bin/"tombi", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
