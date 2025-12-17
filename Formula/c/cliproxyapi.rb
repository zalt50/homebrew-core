class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.25.tar.gz"
  sha256 "99517a359418c8f03e11330a4e06d194134c64dbd79d02667cffc00fbd56800d"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "be4653c28f797c4921b7d816a63df18f53ff6f4014af20ca4f12564e7e964179"
    sha256                               arm64_sequoia: "be4653c28f797c4921b7d816a63df18f53ff6f4014af20ca4f12564e7e964179"
    sha256                               arm64_sonoma:  "be4653c28f797c4921b7d816a63df18f53ff6f4014af20ca4f12564e7e964179"
    sha256 cellar: :any_skip_relocation, sonoma:        "1491c51fe015c6968f7f85c511447c583ac06f63712f92ef39fecdd9f254d003"
    sha256                               arm64_linux:   "571f392f658e9fd73e29e8caaa49f17a6d2b0ac32f39556312866e04634e6bd8"
    sha256                               x86_64_linux:  "7489c7051fc40770f87902bf30b63f227d15d5861d1bedd11b99bfce4fbef602"
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
