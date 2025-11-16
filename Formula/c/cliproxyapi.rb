class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.47.tar.gz"
  sha256 "1f158f3f29fd58de16acd51a4c37c639a68f4c8fda1f0f7e22413f73276c84c6"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "8d3d154b62845e5ee5d1d66256f819efa2b1b49485224631000d4d47bf0c88d3"
    sha256                               arm64_sequoia: "8d3d154b62845e5ee5d1d66256f819efa2b1b49485224631000d4d47bf0c88d3"
    sha256                               arm64_sonoma:  "8d3d154b62845e5ee5d1d66256f819efa2b1b49485224631000d4d47bf0c88d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e7673c14aae1a3e55298df0dcaf6e59be56b6afd3a9ace53aa7eeb28cce6b0d"
    sha256                               arm64_linux:   "f5d1a634d2f7c4ca05528e53256e2d621e21c9247d6ff160e84900b5a3697f84"
    sha256                               x86_64_linux:  "3fa086e5c23886dcb5dbd561fa0b33b34fbde9e38352db431673c3421a9fc256"
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
