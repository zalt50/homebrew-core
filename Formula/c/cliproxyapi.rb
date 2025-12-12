class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.7.tar.gz"
  sha256 "93c65e37f89571b94727e7aeeab22e79dfef2783cd1c7fb42b49db0322095508"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "63507d02eb4258b315db779df8f3784baf6d48af50d8b669747476261b824c22"
    sha256                               arm64_sequoia: "63507d02eb4258b315db779df8f3784baf6d48af50d8b669747476261b824c22"
    sha256                               arm64_sonoma:  "63507d02eb4258b315db779df8f3784baf6d48af50d8b669747476261b824c22"
    sha256 cellar: :any_skip_relocation, sonoma:        "50a1004ca13a0a1ddb80c90c23f6083c7bf51aba7b4173b09fb503742ce4bdc4"
    sha256                               arm64_linux:   "26166c373a07f7faf5ed492c1091653fc14b4f2dbfaa2d2c311edab893ee7457"
    sha256                               x86_64_linux:  "385710c5cacf3c93948b69d7a748a9029dfd73f2f7569e5ad37af4356951898c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Commit=#{tap.user}
      -X main.BuildDate=#{time.iso8601}
      -X main.DefaultConfigPath=#{etc/"cliproxyapi.conf"}
    ]

    system "go", "build", *std_go_args(ldflags:), "cmd/server/main.go"
    etc.install "config.example.yaml" => "cliproxyapi.conf"
  end

  service do
    run [opt_bin/"cliproxyapi"]
    keep_alive true
  end

  test do
    require "pty"
    PTY.spawn(bin/"cliproxyapi", "-login", "-no-browser") do |r, _w, pid|
      sleep 5
      Process.kill "TERM", pid
      assert_match "accounts.google.com", r.read_nonblock(1024)
    end
  end
end
