class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "d00317fedff1f0ac3076e427dc090a9b4b1a6efb62f80742ff774447020d4743"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a186a58422f9fd4c19061646ae6356b3613a5c754df0820205362e65b87d30d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c5fea6e1b47ad750f6f6ae7f3e45f22fff139726dc58097bd2beacbbcdebed5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d17374d400780ffd9d624382a7ea20a94dab1d126254f89147b079b0de4d227f"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0738806901d5666a78ad8209b8dfc251dfe0f5b62efa0173f8111c4273ee8c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3afbfce80557e86774a2d01e21927a7fdec813e7c737cc9c41d18d8ef0638eb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c3bcf7a7ef741fdecf394f6cb909eeabcb837eaf752126f7d33adb5bae4016a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mcp-grafana"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"mcp-grafana", json, 0)
    assert_match "This server provides access to your Grafana instance and the surrounding ecosystem", output
  end
end
