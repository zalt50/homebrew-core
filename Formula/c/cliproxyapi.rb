class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.56.tar.gz"
  sha256 "eb734e31dfa03c6e282f7f213bb4cbeac64228da53d3f339d05a00af0cca8173"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "772691a1a7a5cef7aed60e9ff9c351350d786c3accb2be24b8a69c94c0ab771d"
    sha256                               arm64_sequoia: "772691a1a7a5cef7aed60e9ff9c351350d786c3accb2be24b8a69c94c0ab771d"
    sha256                               arm64_sonoma:  "772691a1a7a5cef7aed60e9ff9c351350d786c3accb2be24b8a69c94c0ab771d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e247d086501cfd5b502d2edd926a9ce3a93cbf17ebe7a28af9dd177db0f7239"
    sha256                               arm64_linux:   "bc41513990072090c4f73a674a3f6482a5d4f38c90ec923c715d2931607af01f"
    sha256                               x86_64_linux:  "01c46b1b8a0dbcab382d8f1f3dc5243a72c1584612642346ce3931bed621a342"
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
