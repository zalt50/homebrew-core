class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.36.tar.gz"
  sha256 "74ba9d7f091cc6d110d609800b7bf992d897ee3bb4a0082adfb97b8d1df234c3"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "3d859d2cb64b8fa578490576fdcba2fcbdfa63866e467784b3c66fa57c62da26"
    sha256                               arm64_sequoia: "3d859d2cb64b8fa578490576fdcba2fcbdfa63866e467784b3c66fa57c62da26"
    sha256                               arm64_sonoma:  "3d859d2cb64b8fa578490576fdcba2fcbdfa63866e467784b3c66fa57c62da26"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8f7682cc3a90d2754a4520960f2ac341de33a218c0c17b717d5202611ee7941"
    sha256                               arm64_linux:   "d7ba9c078f521ed542f3571c94c0d32eb54a4f11ba3fb530c5728fbecc56253b"
    sha256                               x86_64_linux:  "e5c3ed7e38be13c4bab9c9ae9001faa0d5e4cc596fa750b3cf67c30d5556b888"
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
