class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.39.tar.gz"
  sha256 "90331b33bb541c39642e2ba1549fab995e2f8dabc2b2778b80ea5ce1a239e3bc"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "88ecdb442e6abf081bc9093b60df8fe24c15e6698e82e7f77ecdfad9b9f485f7"
    sha256                               arm64_sequoia: "88ecdb442e6abf081bc9093b60df8fe24c15e6698e82e7f77ecdfad9b9f485f7"
    sha256                               arm64_sonoma:  "88ecdb442e6abf081bc9093b60df8fe24c15e6698e82e7f77ecdfad9b9f485f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "70b5cab15c2452129652644c8c9663fbf61400f635cbabc4de55b466ffd8d9de"
    sha256                               arm64_linux:   "44079845c14e49144677fe716cd501782411c8bee0506533c251e9449636e0c1"
    sha256                               x86_64_linux:  "1dc2400586796e5b845cdc85cbe07d67ad4576313d9751c79947d79bc5304c7d"
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
