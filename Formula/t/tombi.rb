class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v1.5.8.tar.gz"
  sha256 "0f6f2475a4db8837efca92ba65f18a2d8416b4ed5aeb8a1ef5f006e19326e888"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5b66bae2df3f672c24a2418c1e276ad3f2b72761f74cd437a9055fc9b45ffb2b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f2349558ecac5220f0b1d7229f6de5861e127980700732c13bebd93d0c313a96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9afce3e7279c86dc6ea92c9fd9f26670b6dee852374eaa43b2ee736f0769dd3b"
    sha256 cellar: :any,                 arm64_linux:       "231c01b929f9f8d1494b0b89c2f263787d8aab4f2f86ad013d3fc60893d84e7f"
    sha256 cellar: :any,                 x86_64_linux:      "e9ef9dffc39310a8fb3fe4a67226efe1b5ef77a923b1e4baf684f3f3f09a0899"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args, "--manifest-path", "rust/tombi-cli/Cargo.toml"
  end

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
