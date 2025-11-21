class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.36.tar.gz"
  sha256 "48ca8369239137879fd259acbdd5f6a69043c6055a29ab4f7678369e229f0e89"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faf2d445f9d557dcbacf7bfb16ad94d009c3a2689d84b69ed4f5b15c2ab55b04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e1bc41880dfb9f0496e81f5dacf1d096ce3a6715ad9b4ca604147a92fa78db5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f43a11a747028fa11e2236015c5dc320c922f64efd82fc1a80eb0624e03d07db"
    sha256 cellar: :any_skip_relocation, sonoma:        "4127a65544ad0f6c3233bc306325121cab8ee746c19bf368f7f12d4548719093"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29553d42f357807e245ab394c3750806b4cf8e781afe34e76224186a81c71e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "052fd07ec7619602b4c045e9009aa5ea09e5e7f55a9808de2282a341e3771a54"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nanobot-ai/nanobot/pkg/version.Tag=v#{version}
      -X github.com/nanobot-ai/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanobot --version")

    pid = spawn bin/"nanobot", "run"
    sleep 1
    assert_path_exists testpath/"nanobot.db"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
