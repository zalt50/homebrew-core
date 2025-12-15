class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.14.tar.gz"
  sha256 "d0311cb3eeb684635ba1d546413014b2f65cb081c3ba1a6434e3d15826b82b94"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "5f2076d2d404f652795e6b37e703b25d0fac0bf2aa6d1ed04be446680543eb65"
    sha256                               arm64_sequoia: "5f2076d2d404f652795e6b37e703b25d0fac0bf2aa6d1ed04be446680543eb65"
    sha256                               arm64_sonoma:  "5f2076d2d404f652795e6b37e703b25d0fac0bf2aa6d1ed04be446680543eb65"
    sha256 cellar: :any_skip_relocation, sonoma:        "b135928e8f780fff8c02839f7711421fb5ff0033dd7acbdbc0376550532ea655"
    sha256                               arm64_linux:   "545f09eacccb68a6b49cf6a846ca90b05e4b9b4f60937eecba100667b89f4d34"
    sha256                               x86_64_linux:  "3d0ee6a4683fc0c4c6dcf09451c37b6023ed78fe996b560cd3223120f002c03d"
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
