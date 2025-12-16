class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.18.tar.gz"
  sha256 "6807314a2cf9f2be73c79b198347ad3fdb101b0d5850385c19c942bd22d7739f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "27d0a90186f70d2e8518923bfb304aaf35035589923187668ff07f79b5c9953e"
    sha256                               arm64_sequoia: "27d0a90186f70d2e8518923bfb304aaf35035589923187668ff07f79b5c9953e"
    sha256                               arm64_sonoma:  "27d0a90186f70d2e8518923bfb304aaf35035589923187668ff07f79b5c9953e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee7021724c78b6eeea5b3a156be293e01afd8309530d263d19c8fb24c44cfa0e"
    sha256                               arm64_linux:   "643b70b7d45d5500a4e0e6e50116763c763fe746bdf8e868c7c2261992a448ce"
    sha256                               x86_64_linux:  "4211cd29b8cfbe67c9d7be457e60ace670c2b2a21a1982363765752191f5ea87"
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
