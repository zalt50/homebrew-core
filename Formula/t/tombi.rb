class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "05207f7216dffd3bc395244d36739f559dbeb4d5fdd3699aa08f300af4c9aa1f"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36cb3844482e0533f476cf30e7e02f9a718d172a309c84d288f3af235525922a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20a7acd478418a81c731584b88fb0231bc8400de2b386071d2d0eced77ed3a17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cd29f6fbe4a657d4b2610cc8832cbd890675f0724a707416c0b256febaebc3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ef1eac7af4f79636eb3f1b8abd2d14216b95591654442572e33b9c5dd72628a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9828711bd72c352a584a02792f3919ce4da533eceb162b1957b2438d6fdab74c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "098cf38aed915f3044d3c7894674dabe93af3c044de45178a1f401876d211887"
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
