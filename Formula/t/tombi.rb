class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "b979d375913be969c6230412e3883fb36c2ecad0a021176563cdfeef8fcb23fe"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ebfe1bbef730fb1380a147345dbb152d23abad5ac3b7f90bad2ce89137ba1168"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2653fa2da4192ec89c5a913545373b9bcc5944a1d9d04859837b77e3d1fbe313"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d593edd392bfe54ec03ed19f2c73cfac8f3bc187c523d41d77fa562655e9e06"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e79fc6b17def51ad2ff9b681c9ba0ed615e3275ba673009d9c6ef3cc854537f"
    sha256 cellar: :any,                 arm64_linux:   "684d08f2a435df9293871f6bdbe34bfedb76096364f8aabc03e63fbbe742ecc6"
    sha256 cellar: :any,                 x86_64_linux:  "1c0758074786ac19f6cef18b9f08572bdca853ba53d6828fb703d4c5255b79a9"
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
