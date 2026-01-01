class JqLsp < Formula
  desc "Jq language server"
  homepage "https://github.com/wader/jq-lsp"
  url "https://github.com/wader/jq-lsp/archive/refs/tags/v0.1.16.tar.gz"
  sha256 "984115bdf6ab8ba155cd72011a75971366dfe240811e4fdba44a957a87cae217"
  license "MIT"
  head "https://github.com/wader/jq-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "115478691dfbe74b6be6e80bdab1af763aeae7b488f21a2af2f17ee79419035f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "115478691dfbe74b6be6e80bdab1af763aeae7b488f21a2af2f17ee79419035f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "115478691dfbe74b6be6e80bdab1af763aeae7b488f21a2af2f17ee79419035f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1e445a4064ce44be225fc606c2fcff75917feeed398f02a5b9ee5d125a5028d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbf7411589b3489a6efc411cb4eede66c46280d70b8794cd4d5b9c97edc4a176"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f62f9d9aec3e138c6c4bed4654b9c104636b31eff1a8c0d664c8585b5fc0293"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jq-lsp --version")

    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "processId": 88075,
          "rootUri": null,
          "capabilities": {},
          "trace": "verbose",
          "workspaceFolders": null
        }
      }
    JSON

    Open3.popen3(bin/"jq-lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
