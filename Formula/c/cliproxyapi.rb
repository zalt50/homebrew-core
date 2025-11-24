class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.15.tar.gz"
  sha256 "8f879c9a153ad02ff584fe1b9d5775d40480b8287b5d63dd90e036fd03e2cd36"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b1a7c3a35b28ef2c3a3e7a741c4e9e227b8c26543d6955f52062896c7cfa5854"
    sha256                               arm64_sequoia: "b1a7c3a35b28ef2c3a3e7a741c4e9e227b8c26543d6955f52062896c7cfa5854"
    sha256                               arm64_sonoma:  "b1a7c3a35b28ef2c3a3e7a741c4e9e227b8c26543d6955f52062896c7cfa5854"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e9d294cf03c6dd43c5f888475a3379fdcafabaaa1f16d0a2a489c680943dc01"
    sha256                               arm64_linux:   "53aa31d2a6e028579ce3c55e3b31a97d3f9685b1e27bdec568f30ebca801bdd5"
    sha256                               x86_64_linux:  "1e743417f74cd08b53fb2d9b72ba95978f04b185f6b90aface823596c3292fdf"
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
