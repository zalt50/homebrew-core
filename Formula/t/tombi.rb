class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "fea32038db8bca1f4833d4040dff7fb5f35e8991efcd02f6a85d9769953ea281"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42818d8e04f7e5b00a99fca07d11d1c0a57c1f1a344f132199eed4a042a980f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33ba781422c822906ed409c1482765f7e504f5de5d55cd8a7a2a650198c760e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cc2a21232598c4938dc95010fa719f4aaf4980739c47ff9ef26eeb144ba21e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "025885c0c66e20edaf8dfe5d1b1c8fb0e7bc59ecbf51d4256759e7b4d8b31c2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d5246ff5d3ed82e92f28cf7bfc2333f0cb641ff1e0809c9adbbed47f1e20998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "367c10ebc1f54510788c0352cb2dc3da8dd1fa744a11816f13c4e9050ef9b73d"
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
