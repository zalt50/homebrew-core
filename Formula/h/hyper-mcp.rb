class HyperMcp < Formula
  desc "MCP server that extends its capabilities through WebAssembly plugins"
  homepage "https://github.com/hyper-mcp-rs/hyper-mcp"
  url "https://github.com/hyper-mcp-rs/hyper-mcp/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "e66467d08c70322ca4a496d3178ec950798ab4a519fa31d20ee4e5ff930ad0c3"
  license "Apache-2.0"
  head "https://github.com/hyper-mcp-rs/hyper-mcp.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01d8f1cdd4a3264e4e907c69be744d2c5003166a0f39a95587556db9be73910d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c03a744880f5705a2230cc824d9ce592308024f75d58c316fb46ea83326f08a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "942ead17a292b55d14e1e5d6708a7b1a7524bfc62a71a7c00fcfb092d9a432a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3d7dbe12ce736cebd02cf12ddcbf0eed4e705364457259666fb5ba2115310f0"
    sha256 cellar: :any,                 arm64_linux:   "9d3d4b04d85e3583defcbf3c4219a9fe26350b5a64ff3eb82ca2dea9088ec15d"
    sha256 cellar: :any,                 x86_64_linux:  "028bdcc862cf2240ef86cc472815a2631e958c7cafde56c41fe53613573c493b"
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
