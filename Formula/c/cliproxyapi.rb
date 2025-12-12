class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.6.tar.gz"
  sha256 "5e0c64933c09510d21656f51d4de898af512d459e42e67a71bfeef6d5f3cb931"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "30e2152a0d8ebe68f1b33ae8de37393ae60c7bb64ee44906fdbd8f5c301282c1"
    sha256                               arm64_sequoia: "30e2152a0d8ebe68f1b33ae8de37393ae60c7bb64ee44906fdbd8f5c301282c1"
    sha256                               arm64_sonoma:  "30e2152a0d8ebe68f1b33ae8de37393ae60c7bb64ee44906fdbd8f5c301282c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2b96d2469e4d20ceb7ec6a91644045fe47aa8effd3504a1a757a23a1eb0a7e1"
    sha256                               arm64_linux:   "a67f5b8d8a4001362f9bb8c139afd633f634deaf455312fac9758559995d17f5"
    sha256                               x86_64_linux:  "ac4670aa4cccad16558b8b703de192aa2b8eafc3f374d92adfea1fd3006f6c24"
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
