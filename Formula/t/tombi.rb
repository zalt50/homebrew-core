class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "d3fe8c23fd3154a8e2fe60bdfc8271444cfcce2817a04c8d2d0dcc7a25ff7644"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53b8b135605383d625ba32d146a9a1c3681c981ae14e93a39b33bf254d0c9306"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a61d839f15397e17e44ec6d7c9509e34a89b38b8055ae252cdbdfcf98a338071"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8510842aadb8b943f4b9ed1b66f8231049f86e0381abab106ee70d8030316bc5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c39510c12c5c12a5a90aafc8745df6cf6512ca977bb8fa1bfb178a8df19b3a97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c41d42b88ccb7b2eeecba917045f07d1193fd4c3157b03750615dda71b668e5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0a8432884aa6d3c096bb82c6d83a16f7e07a75755c57130a889c4aaefb8f8b3"
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
