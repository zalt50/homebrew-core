class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.27.tar.gz"
  sha256 "debb7cdaad2c10448ba89f9fcb1e555a23f311955562dc9d76ce93d6fa5ef370"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "fd43f35a1b54240c70d1cdf24cf7f342cf7be03aec46a5664776570c633a8693"
    sha256                               arm64_sequoia: "fd43f35a1b54240c70d1cdf24cf7f342cf7be03aec46a5664776570c633a8693"
    sha256                               arm64_sonoma:  "fd43f35a1b54240c70d1cdf24cf7f342cf7be03aec46a5664776570c633a8693"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6a02b0a923ebae13746727cc18c3acb8eadd9272ed0f29006a5c910ed4a3e04"
    sha256                               arm64_linux:   "83305329d37dd9c8e9f819e0b026b2fe88ef39011d2cdc7123ebfd0e3f12134a"
    sha256                               x86_64_linux:  "b132cfa3c8b30fb32e879d1383fd30c6f5f7babababaf95e2ddb735202b552b7"
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
