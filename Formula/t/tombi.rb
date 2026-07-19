class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "dfd54d29428d5ebf2ab81ec8c66fe0fb90fd185c34ca3d80a386c655b8678896"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b852abfd37e17fc01543702233de1f924078b0fba670f51899d20cdb72cea174"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf840b520e8b9322ebc8db7c2f76878f223ebc477cfa49db97a85ec6c1e5545c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58a5f372bfc2b317a6e7092342a37f00d05e60609904a9d9b42d348331b800f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e76fd848c65e127e3223bb2e9ecb94a75f1322ab797161cbdb1f587b3f5d46a3"
    sha256 cellar: :any,                 arm64_linux:   "58bcdb8f3ae5de6f3f9d7603ce9d6a92f915f0270df4d8389ea942213156cf16"
    sha256 cellar: :any,                 x86_64_linux:  "8d021811839e2a2b83fbc7aaa68d71030523c940f6f41b62723c9511442558d6"
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
