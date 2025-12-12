class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.5.tar.gz"
  sha256 "d8cd007eddb5d5eac3e0a0eda5316689a623de276328b190980772d56b6fae44"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0e0388d1c0f2e9769cd87c1cfead2ec5f07d7c4e60ae722a8b166540ab16d35a"
    sha256                               arm64_sequoia: "0e0388d1c0f2e9769cd87c1cfead2ec5f07d7c4e60ae722a8b166540ab16d35a"
    sha256                               arm64_sonoma:  "0e0388d1c0f2e9769cd87c1cfead2ec5f07d7c4e60ae722a8b166540ab16d35a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c7cc930e7263c3b63998e36e4b0dde8f172614fa4a8ac1ced1fe8aeafcd7332"
    sha256                               arm64_linux:   "5d63f0d36bfb2e8d6b0a9d6adf23efd3a757102b9d5966248790a27ee68e23f0"
    sha256                               x86_64_linux:  "c9eab2855cba4f36e44bd57b1c745ca2995d47b5c4a5aeb267e19a6548fb6c77"
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
