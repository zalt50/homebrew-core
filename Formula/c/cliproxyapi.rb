class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.35.tar.gz"
  sha256 "7d0341b30c19c47eb469641c3aea36ff6d819a3fc6d2db237c4ff8786ebbdf81"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b092b151fe2359b9a5f5fcda77421bf3476ad69391e14374262326f68c6f7659"
    sha256                               arm64_sequoia: "b092b151fe2359b9a5f5fcda77421bf3476ad69391e14374262326f68c6f7659"
    sha256                               arm64_sonoma:  "b092b151fe2359b9a5f5fcda77421bf3476ad69391e14374262326f68c6f7659"
    sha256 cellar: :any_skip_relocation, sonoma:        "2aa04ce8127f5cae41d26957e76bd2683ee877d269d8b167c3e8020644c9e1a3"
    sha256                               arm64_linux:   "d5a8bd9e40191103d620b07057a5d8bb6332454b94f2214a4efde33255f2225f"
    sha256                               x86_64_linux:  "c956a79f549f315d408c6c4a3261247be5866353a6d0e918545b33f0670542ec"
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
