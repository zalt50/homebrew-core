class GithubMcpServer < Formula
  desc "GitHub Model Context Protocol server for AI tools"
  homepage "https://github.com/github/github-mcp-server"
  url "https://github.com/github/github-mcp-server/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "3c64fed3846871723a08acde181a941ce76106b5838181e11bb6fe2efe0a4037"
  license "MIT"
  head "https://github.com/github/github-mcp-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a65fbce3c6b2b426c30282f6ef9baeec6061a69e0f4680540ac22d9a494152f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a65fbce3c6b2b426c30282f6ef9baeec6061a69e0f4680540ac22d9a494152f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a65fbce3c6b2b426c30282f6ef9baeec6061a69e0f4680540ac22d9a494152f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1c0aaed5fd5f82636542a92afc47c021377f498c101138de797bca8ef8ff4e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca6ba62677bbbce709f1f9e0ea045e6b4835c93b5763af87021d82f84d72cd78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f699e687feec5e2e7eb1660e5fa70d6ab76c68e8151788bff819397fe8a7f8a"
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
      {
        "jsonrpc": "2.0",
        "id": 3,
        "params": {
          "name": "get_me"
        },
        "method": "tools/call"
      }
    JSON

    assert_match "GitHub MCP Server running on stdio", pipe_output("#{bin}/github-mcp-server stdio 2>&1", json, 0)
  end
end
