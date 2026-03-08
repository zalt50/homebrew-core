class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "5d0ea952adc31b6f49f7e90bcb528c505ccd9b24b07b0920e64aa3390ac9b602"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21bf2286bd737a0fb6a0ed38873407a57decd7b12a32a9ae93326f54463abe81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52663d1cfb526d7fa8cce1f5f6f5b2fe3914738569bf39e68ad450415c727309"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75867788b8be089b25b9f161c0331a8070b8ea92a283496b91aa9ddf7faccad5"
    sha256 cellar: :any_skip_relocation, sonoma:        "853d499811b54d9e0538c4716e6370f7294133d9a00442ead82891735d8ae7da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15b878b1bbdb6612f31b4b60637e4e4cf0edb9edd0b7489068949ca502ea9109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9ab315f30cafe25b096ffa5f7ff94c444539cfd6efc7d4524dc00f486dfe640"
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
