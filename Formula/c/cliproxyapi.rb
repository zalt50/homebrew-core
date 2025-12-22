class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.41.tar.gz"
  sha256 "5b1341730dc8f3ff4ebe22703d98d406de2b24914728e46953a9e0e61773a2a1"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "74cdb4e49fd609d18d462e009b2ff78257254096a43ae70a81626700953fc347"
    sha256                               arm64_sequoia: "74cdb4e49fd609d18d462e009b2ff78257254096a43ae70a81626700953fc347"
    sha256                               arm64_sonoma:  "74cdb4e49fd609d18d462e009b2ff78257254096a43ae70a81626700953fc347"
    sha256 cellar: :any_skip_relocation, sonoma:        "beae32b9352dbc3cc53cb082df9ed25bcba677b7b22f7f425e06bcf2d3d6d7f4"
    sha256                               arm64_linux:   "233722305719b493c7f6fc735d9978abe51c3d62a1b1af8772544fcf677816d7"
    sha256                               x86_64_linux:  "2c31f243e0b91575ea486491f93305018f2322a86e17278a699bc09cf45d9881"
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
