class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.50.tar.gz"
  sha256 "0f602ffcfdcfa79e52fde3226cdbeff9ee5be8b7a0331d76e0e23daaa2c38924"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e385ad7d68ae6d3d131e6abdf4c32ab86c36a027e2c17c1e9bcd955b145579f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b89a4640dd356d30b3e9925026591b9c37cfd135b6a68d6bc90e36867124d7e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d414e543f300e38b07b0670b57a763832966443b18a889acb6044aaea5de42e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b2e88b6a86ac4965a8b70ed6ca370e99796bfa796e54065112333e06b59c84c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "005bc7a6914525e7c9fb95002281e1878d4f2d6e88059bbccf155462805e492e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "063e7d7aba2f1073aeac5ee77d80fdd42a153b57fda932223df6672458d555df"
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
