class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.32.tar.gz"
  sha256 "a0d4ec51c56063a6d6f6e7e1203ce3d08bd7b743c242dd727090647fe701f9f7"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "4f0f50039b16934829773f0948f99cc25ac65a7542cbe4936f8006807d31fb45"
    sha256                               arm64_sequoia: "4f0f50039b16934829773f0948f99cc25ac65a7542cbe4936f8006807d31fb45"
    sha256                               arm64_sonoma:  "4f0f50039b16934829773f0948f99cc25ac65a7542cbe4936f8006807d31fb45"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f14c0ba952adf22d6ec92ab2e93fca802d70d88e853abd5f6b6c88d5c41374d"
    sha256                               arm64_linux:   "6e85a5b2f9e176252636c1420e828e968e976aa59774d30db63584dd3bb3ed98"
    sha256                               x86_64_linux:  "0614c6761514c71561b63cc9bc907f76fe711134885350a6b5a6cd0ea28b8eea"
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
