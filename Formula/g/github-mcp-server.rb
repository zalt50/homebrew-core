class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "a925eb758a60092ed3eb7cd58ec999c0a30dade37d034cae11c48f6fcb8c9e5f"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "648d6fce8ab628e9d9e671938403ca0701ae318ea00fdc3e03013f25b1d9ef8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "648d6fce8ab628e9d9e671938403ca0701ae318ea00fdc3e03013f25b1d9ef8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "648d6fce8ab628e9d9e671938403ca0701ae318ea00fdc3e03013f25b1d9ef8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3950922d8784185be66ebeda4ffb16afe9355b976314cb74952c000e4e810d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e0eb2c05e4eeb488c5db476d09a2e0be630ea56ffaa9604f19e049856e61cde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b74912aac17e22878cd228cc1204a42b75d9390e57a4343e8709919999e02f75"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/github-mcp-server"

    generate_completions_from_executable(bin/"github-mcp-server", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/github-mcp-server --version")

    ENV["GITHUB_PERSONAL_ACCESS_TOKEN"] = "test"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}
      {"jsonrpc":"2.0","method":"notifications/initialized","params":{}}
    JSON

    out = pipe_output("#{bin}/github-mcp-server stdio 2>&1", json, 1)
    assert_includes out, "GitHub MCP Server running on stdio"
  end
end
