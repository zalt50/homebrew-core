class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "fbe867ad8608e2ef41064b8c9bf6f059a28b57f82cec815c3074def3a1dd3bd8"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc2678efbe96fe0e02aee837ebf7a1b666f0724d033ead5d25509d0f52ef44e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc2678efbe96fe0e02aee837ebf7a1b666f0724d033ead5d25509d0f52ef44e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc2678efbe96fe0e02aee837ebf7a1b666f0724d033ead5d25509d0f52ef44e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "76fcecc64231e3d13303184d4a94694cd97da3854318547d7f29e7e1451e5110"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a316f14cfe775a7f93c020c7e6fd9400c4a80bbad865da3bbad97b642050ff26"
    sha256 cellar: :any,                 x86_64_linux:  "f4826e1b15cc7b3b7b9dfc292e8819a55312a1f2150f23923f8fe626296d8986"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/github-mcp-server"

    generate_completions_from_executable(bin/"github-mcp-server", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/github-mcp-server --version")

    ENV["GITHUB_PERSONAL_ACCESS_TOKEN"] = "test"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
    JSON

    out = pipe_output("#{bin}/github-mcp-server stdio 2>&1", json)
    assert_includes out, "GitHub MCP Server running on stdio"
  end
end
