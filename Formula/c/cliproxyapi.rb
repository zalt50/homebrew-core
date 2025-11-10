class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.29.tar.gz"
  sha256 "ab2c68e2a1bdb2791a3961cc75daaa43b412bce3a6a60a4a696ecc743b79ccf9"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "52355be025d1c10acb67bf3b648216d87bc9c4f669778de5b82b2e0ce7b5abbc"
    sha256                               arm64_sequoia: "52355be025d1c10acb67bf3b648216d87bc9c4f669778de5b82b2e0ce7b5abbc"
    sha256                               arm64_sonoma:  "52355be025d1c10acb67bf3b648216d87bc9c4f669778de5b82b2e0ce7b5abbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "09b8244e352c80bf65b53922b07444e2f351d461b6d4cca53db2a3297e5e4120"
    sha256                               arm64_linux:   "404f4f1fdd3c1895b4d4ac8e754a06f98326719d8303da4901fee81bad402e29"
    sha256                               x86_64_linux:  "dbaeeafc262b1bd99b04302b47aa9da4ab008b1ef6243bf15b9ec4de81f50b2b"
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
