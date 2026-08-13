class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "ba3f173c94c51b9dbf9be3658e2a898c00f9e57963c5fe5a22ea3e0a4496db71"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6926b1ca7f9b64e2ac48b979fedc305492ae2fde96b0a3248ba5b59fc7ffc8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d011c2548526320b82d1a050c7fe53be5a243c1736cba8847aa02de1ff2532f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c59b23aa2ef78320209e491a6c5be6664bf2c32ce5a656f2ab716c5477f267d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1627f80cfd164c6e53129eaf1e3f4d9f1a0681d5e4c8fc0880135e16f1a68691"
    sha256 cellar: :any,                 arm64_linux:   "83c4c33a76848492425a608c2ea019a80a6694218ec9b43866db2ebfe336d9b5"
    sha256 cellar: :any,                 x86_64_linux:  "604c3537c2087df6a1c3d63897a15783934a0b7cead5a5e0ff286c5ddc9aff78"
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
