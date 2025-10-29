class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "3807baed298714540b24126f16a6297f74cb526a69b6657af985d60975db3e02"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bca969bf1f9e707955ab5cbd559f8ff3bc67f526988daf8d1daa58c97b652c92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bca969bf1f9e707955ab5cbd559f8ff3bc67f526988daf8d1daa58c97b652c92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bca969bf1f9e707955ab5cbd559f8ff3bc67f526988daf8d1daa58c97b652c92"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e4483f7787d1feebbc54af7acb6d4b70bfbf77279fa7db775f04214a3fe560e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9daef2621ad03312612b04e127cc737f3f19129d07ebc0fbaae3aba00459ed56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24a6e9cae5b3957b8fe53872af3bbb29671b83d74e60faf9a99663234297a626"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.GitCommit=#{tap.user} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/publisher"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-publisher --version 2>&1")
    assert_match "Created server.json", shell_output("#{bin}/mcp-publisher init")
    assert_match "io.github.YOUR_USERNAME/YOUR_REPO", (testpath/"server.json").read
  end
end
