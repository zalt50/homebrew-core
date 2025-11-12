class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.47.tar.gz"
  sha256 "e046bf1097c84615c2e00198536b8e7c8d2c67c47bd4daa9b7a56fce45d33749"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f11cb02d644f4c1d23636a014d8a3d68b7a7e5a763b5fc238aad20387c27c461"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c48d8b015d4f5929b2fdfa515c54a4cb4fecda09909e04ee49039487d937ce9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4507b0687b0a31fed274e5bbafc4a79ef906be02af571bfc012dcc985db3c86f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae1ae3e6d5dae2cfce5e56b55a6faceb0b5e08f65d768a2e72ba5aa588a8982e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5a439160506ad25b9d048af940050b94a14aafc9a99b49d2c84395f37e572a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43842df0c473c1ebe901e17fb9af9d8abf951158262cf5417426f357eb0276f7"
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
