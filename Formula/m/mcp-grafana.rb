class McpGrafana < Formula
  desc "MCP server for Grafana"
  homepage "https://github.com/grafana/mcp-grafana"
  url "https://github.com/grafana/mcp-grafana/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "89a24ba3d67b784a22bbb2a5e529dc7e0afdff50c5c6005dd04df5c00b050baa"
  license "Apache-2.0"
  head "https://github.com/grafana/mcp-grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6ffbc95e220cd3724dd01b5e37c7dde9ebeda7bfdc9a8d8a9c243e2c5626d787"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "95f259bddd672c371d544d4bfb90ff6ee448c058d08ddd31071aa2185def8590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3ba649d7c025373169306e50bb214202203cc5dd2146e2cc8d8d1240654463d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9ceef45328cdd0f9eb1be2d25c9fed15fe81709a11849de697aff014aa3046b6"
    sha256 cellar: :any,                 x86_64_linux:      "fc86b0a99e26e3e50be501bcf9ac76d986f3b0d7dd124d06980a2021f6925258"
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
    IO.popen([bin/"mcp-grafana", "--usage-stats=disabled"], "r+") do |pipe|
      Timeout.timeout(30) do
        pipe.puts JSON.generate(jsonrpc: "2.0", id: 1, method: "initialize", params: {
          protocolVersion: "2025-03-26", capabilities: {}, clientInfo: { name: "homebrew", version: "1.0" }
        })
        response = JSON.parse(pipe.readline)
        assert_equal 1, response.fetch("id")
        assert_match "This server provides access to your Grafana instance and the surrounding ecosystem",
                     response.fetch("result").fetch("instructions")

        pipe.puts JSON.generate(jsonrpc: "2.0", method: "notifications/initialized")
        pipe.puts JSON.generate(jsonrpc: "2.0", id: 2, method: "tools/list")
        response = JSON.parse(pipe.readline)
        assert_equal 2, response.fetch("id")
        tools = response.fetch("result").fetch("tools").map { |tool| tool.fetch("name") }
        assert_includes tools, "list_datasources"
        assert_includes tools, "query_prometheus"
      end
    end
  end
end
