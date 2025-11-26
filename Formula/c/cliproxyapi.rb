class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.24.tar.gz"
  sha256 "df4afdef4b186026104f5eef00611c33914d8b22645c1c1a3c7478c305b346a8"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "5926d01819a3b8498463e75715f7f4c41050ee69de84c0680ace592798a9541b"
    sha256                               arm64_sequoia: "5926d01819a3b8498463e75715f7f4c41050ee69de84c0680ace592798a9541b"
    sha256                               arm64_sonoma:  "5926d01819a3b8498463e75715f7f4c41050ee69de84c0680ace592798a9541b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb0bca46e281c4efb01782b74dcaefc6d3063ea2a184c12e6d95f20858d1bbc9"
    sha256                               arm64_linux:   "d94c26c38e8d67319b87721b6907723ad86c65e7fea3e565ae4f93dc60017ced"
    sha256                               x86_64_linux:  "a55e0c6beb01c74ea370432f65621b51deadeabf5c0f3ff8900bc93b3731226f"
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
