class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.44.tar.gz"
  sha256 "6280db79cbb3d81f97c54cc491f9892f3217fa46f445cd331d895bdedd74692d"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "141cf849f37d84328a9f3bc0e2613a3936e8455e35b1081c37de5c3f597c5ab8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d99bfb44a5e2a984a226985cf3c9452f1567d8c6418d4f6a8ca3b863b0388c8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6be4d52c87f53ee57751e863a07ffa5fa31e37e7a28f865cbaa08b6cf5accfee"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2c81ea90ef6f9fa732204155ba0b97b70bc62f30fb1c3fc73ed8edf6fa138e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a22c802ab41603986f87ba3e6cbc536b734bc2639ed85c02984bf07ce2c4368a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cf451bb427abaf46b49df2063c5992b1684758181dd45a1bb258caf3aa8e509"
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
