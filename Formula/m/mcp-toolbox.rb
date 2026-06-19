class McpToolbox < Formula
  desc "MCP server for databases"
  homepage "https://github.com/googleapis/genai-toolbox"
  url "https://github.com/googleapis/genai-toolbox/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "af70745e34a51f188659c629d918f0cd51c21cc563676a72eae878776d20e166"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e29a151df3add43fff593ceac9e3c1d6e29ceed4852e7c562fc76a22e673066"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "157efb90ee307864e292a868e06f5b21976d1e94b9209ab03c769a36cd5727e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "806011fd91aa16e6d98e2b8b3ad899721de831e7a04d13323e5134fc2115975e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e17ae93774df43830264fc5100b5da2f802533cffb4391da93c16485e8dbb28"
    sha256 cellar: :any,                 arm64_linux:   "fc5ddb6a1963e3ee1ccff186361e87254fcf427be6a4d83256bff566c2799c25"
    sha256 cellar: :any,                 x86_64_linux:  "d15eccccd183889d73157ef6ada817daee0e87635e3c5e9c30d46cf356b15388"
  end

  depends_on "go" => :build

  conflicts_with "kahip", because: "both install `toolbox` binaries"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/googleapis/genai-toolbox/cmd.buildType=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"toolbox")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toolbox --version")

    (testpath/"tools.yaml").write <<~YAML
      sources:
        my-sqlite-memory-db:
          kind: "sqlite"
          database: ":memory:"
    YAML

    port = free_port
    pid = spawn bin/"toolbox", "--tools-file", testpath/"tools.yaml", "--port", port.to_s

    begin
      sleep 5
      output = shell_output("curl -s -i http://localhost:#{port} 2>&1")
      assert_match "HTTP/1.1 200 OK", output, "Expected HTTP/1.1 200 OK response"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
