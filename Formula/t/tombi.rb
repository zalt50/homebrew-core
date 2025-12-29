class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.14.tar.gz"
  sha256 "7a919d149d7cdf3e38f5e96b95e9c0e250bb98720a5066972114586a0338362d"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2efda3e6a75807d79b26fd0f792655b70d96175ac7f03952edce21ea523f5fca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a1d612dd0e32a03586a95214e16ff53b41a1e9bdfa4e75d2eaed446ce8360aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ebdb6cce3af18aa9f4ea03004dbe507f306d8df5152c68064920f9169da1b027"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8c95946278da2a43e07643d59be921aa150d8b77892895745f20d66f7cbc6dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86b870ea29e01189dcd26e71937269335392f6a2618267faa6bbb6027fed2f4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecdf44196eb5de1dda75fc5b6b60c4837d667dc2add66cf13a18c59059dc88ed"
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
