class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.23.tar.gz"
  sha256 "f828304f23db0427c4a2928dd8b9d263ee3f27ed55901127e36ef96196e321b5"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b90c89a4b1b7c5cef0e8363efff1edd177203cacb7f64068404be0be5bf997ff"
    sha256                               arm64_sequoia: "b90c89a4b1b7c5cef0e8363efff1edd177203cacb7f64068404be0be5bf997ff"
    sha256                               arm64_sonoma:  "b90c89a4b1b7c5cef0e8363efff1edd177203cacb7f64068404be0be5bf997ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2f9dc2a14a87c4b7f232471743b8d6561262c01b3f491d00361f8ab239b6db4"
    sha256                               arm64_linux:   "1aa00a69f636227e6544b6f00ea599fb2ad554000739e98a82e8a6f4f1c46547"
    sha256                               x86_64_linux:  "6415531938989253c20baa14a87f224b3012fbdcc43eafc985fc5d34bb84265b"
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
