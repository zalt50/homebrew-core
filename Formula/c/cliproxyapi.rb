class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.37.tar.gz"
  sha256 "762d642abc406599be3207992eba6dd2bc21a4776232674f397cf1210159332a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "4bb552acbf6b02eb1020bb94c3cd60e30fd116cc206b8d9a46bbefb25c606865"
    sha256                               arm64_sequoia: "4bb552acbf6b02eb1020bb94c3cd60e30fd116cc206b8d9a46bbefb25c606865"
    sha256                               arm64_sonoma:  "4bb552acbf6b02eb1020bb94c3cd60e30fd116cc206b8d9a46bbefb25c606865"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce75d505e7778f48404e8f3a967314bd87eefd2f944d729ac141b545989d1fec"
    sha256                               arm64_linux:   "2e461d27bb64dc9b32840033303b68b911d16746c12a73d3c0d3975b20a21825"
    sha256                               x86_64_linux:  "a34a0736f75587ff96a60d79b3c737949854851bc0bad2b8f4019010c133b8b1"
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
