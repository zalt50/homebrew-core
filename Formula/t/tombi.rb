class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.52.tar.gz"
  sha256 "7a9d1143146e20b7c2581edd6df596af93a01b10410710e4893dd2bb0bdb54a6"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bcfc1f9f1564ed584d9d8cb2763cb11354ece65065c5de98de4fb7c02dc7fb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "477f476f14389b6388dcaf4388ed9604212e049770d4ef6b0d5b64888fa4b820"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a286cf78df782e7050daf45cd4b3edd1159efa7e7f951e5c6ec04ebc7b5d35d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e6a41d697b0b1090719d14b147ff81340020aee5747972bf01cc8789b929f6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa543edd6c0f93ecce444cf5c98b07253f9c39b0f41ce78f4a8b1f835e167c27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06212e7dbf9b6afb0b23acf0ea2de5b667b58ea671d5674dd370917cc5b753e0"
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
