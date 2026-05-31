class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "5e2717e3b552f11f8025dd9609e835ede64d0396a3d20ce27ea32e08cef9d580"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a93ac65edee12cedd31f1e82d42857dec9171dc2e9714126ec0e9df5b7199dda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c500f9bf7d30d77162afe17ce6c940044fe73c67c76d4c40a252c5e4b8c9bd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "796fc906273ac0f78c432850aac8ec8ab762588fac926442578c06a41d64a275"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b0c57e0c33f10999b7c638d8c45bd9a5df2fd5770fdb0d8b6c40df42ef7110f"
    sha256 cellar: :any,                 arm64_linux:   "db9698422587fb85611cd79220b8c517725b655b398c03d713a2ee4a8c99c8e9"
    sha256 cellar: :any,                 x86_64_linux:  "36514a20d1c306f446fbe384c07ac83775a524d3529d90491bb267fd74b9c3a5"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"config.json").write <<~JSON
      {
        "plugins": {}
      }
    JSON

    init_json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "protocolVersion": "2024-11-05",
          "capabilities": {
            "roots": {},
            "sampling": {},
            "experimental": {}
          },
          "clientInfo": {
            "name": "hyper-mcp",
            "version": "#{version}"
          }
        }
      }
    JSON

    require "open3"
    Open3.popen3(bin/"hyper-mcp", "--config-file", testpath/"config.json") do |stdin, stdout, _, w|
      sleep 2
      stdin.puts JSON.generate(JSON.parse(init_json))
      Timeout.timeout(10) do
        stdout.each do |line|
          break if line.include? "\"version\":\"#{version}\""
        end
      end
      stdin.close
    ensure
      Process.kill "TERM", w.pid
    end
  end
end
