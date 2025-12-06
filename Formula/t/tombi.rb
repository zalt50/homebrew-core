class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "f4cc5a7e6143bd5bb894cfdf5b8708a2de82f8240e03f4dd1badcc5f6eb5034d"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1605b64fe1d00d28fa4f7c14a636d9b95aa4c1bdb2e3b7b5b76b8227a8ba19f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a424440feff92e8f959d4ace1fdfbbba353b013019b7be026a8c11b85a3982f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b75f8b462900319a49b6ab1ce74d4c90a00890a70e31102eb0005bf2bf72af7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fc47718e10385c32ce31f879c932de2d743a976ec2e26b659059ea3124b3468"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "489f5e2f484ae29a20059c3951df37f48a801002803db3b4833777d23f310694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e9fb850e6e0fe5fda75d6b0522af2d6a2f1f7f37eddf14d22a81367a03815bf"
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
