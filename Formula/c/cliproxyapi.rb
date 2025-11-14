class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.43.tar.gz"
  sha256 "db9b1c025a7c4701574040ca09368646a42b956bf21d002c8fd5ee232bf14444"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0c4f10986efc5894ef0c2a787a3df4931e9a7ab6c77cc7581ab1128c3e83c555"
    sha256                               arm64_sequoia: "0c4f10986efc5894ef0c2a787a3df4931e9a7ab6c77cc7581ab1128c3e83c555"
    sha256                               arm64_sonoma:  "0c4f10986efc5894ef0c2a787a3df4931e9a7ab6c77cc7581ab1128c3e83c555"
    sha256 cellar: :any_skip_relocation, sonoma:        "6362755bacbf5080e45b127eb9bef62d9403eb452501abb7c1b2be0895563250"
    sha256                               arm64_linux:   "9962688f74f2d6091f351312d79e05189928ae0705a826feee08781fdc852fb7"
    sha256                               x86_64_linux:  "b9f1be289539516287d5491c9b7f8d6fb208fe1410286de06a0e31b299069b97"
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
