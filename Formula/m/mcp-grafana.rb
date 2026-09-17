class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "bcae77e9b2c6bda4a609e216dbf07c1058b993cef9a32f65c839e46d7d44ed94"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9ed9cac4ab8b566201a69ee0a9199c847ec182fdccae496dc7c285c7d690cf0a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd4ff88b5df079b47b462e6bf852458113c52a7ce1896ccb2a45f38fb718061b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c015bf0585797489eb30394028faf0485c9352e60d79101606dccd298db96dc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "96ca1e159ecc1841122a40c91124357eb198fbf83a59b3af20714512c7482987"
    sha256 cellar: :any,                 x86_64_linux:      "98b948b9522a3d7e600384e4f0b5d42bdda40cf27c3d229bb3218a3a3f64f957"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/mcp-grafana"
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
