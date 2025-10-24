class McpPublisher < Formula
  desc "Publisher CLI tool for the Official Model Context Protocol (MCP) Registry"
  homepage "https://github.com/modelcontextprotocol/registry"
  url "https://github.com/modelcontextprotocol/registry/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "21124273c16d81dc9d61065da93e865848de7be680802de150599681f96b8a7a"
  license "MIT"
  head "https://github.com/modelcontextprotocol/registry.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8317af279fbd42d0dab19928dda6154d401e72af64678f2a98db8c903f0c652"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8317af279fbd42d0dab19928dda6154d401e72af64678f2a98db8c903f0c652"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8317af279fbd42d0dab19928dda6154d401e72af64678f2a98db8c903f0c652"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3816244b9ea812d200e204546ddb7021e01275650d51c4f1808e786229278b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b317401a52255e94eaa89f26e38e6b7784416bee2aa7bc727113f9f7345c0d93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f97a4a8068c8d1ba1b9fee87640f6cbd45d4faad365456a8f222a7e08f9b919e"
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
