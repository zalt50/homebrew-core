class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.9.tar.gz"
  sha256 "d3014d2046a0ffde0c207a83252d02e2e16c1ec4f341b04e767fe1a72afa1c0c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "9dcad38ff5cf1a08e0c3e08a75afec993b9e8f8a5fdf9f2d19c6617af9041086"
    sha256                               arm64_sequoia: "9dcad38ff5cf1a08e0c3e08a75afec993b9e8f8a5fdf9f2d19c6617af9041086"
    sha256                               arm64_sonoma:  "9dcad38ff5cf1a08e0c3e08a75afec993b9e8f8a5fdf9f2d19c6617af9041086"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc15c39ebd2aabb66dfd4f1477aa6cca9b01bb2e380deafd21a12d31c82cc691"
    sha256                               arm64_linux:   "e3b8234ab46a96993299a69e9a2001bf489239a578ea774f2d1d4600ac495446"
    sha256                               x86_64_linux:  "f3247ccd73bc1988da5287dec8e1d8db0ed4f071af38872b4f243bc9590d6a90"
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
