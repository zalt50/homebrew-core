class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.38.tar.gz"
  sha256 "69bafdbae304ceaf73e5da3c1a50b4ecd3879d148f7705af23335bff0bb5bfb9"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "4db600489203ee39c197e8a1cab2b73ff3d55691f744fcb583b17982b1ff78f1"
    sha256                               arm64_sequoia: "4db600489203ee39c197e8a1cab2b73ff3d55691f744fcb583b17982b1ff78f1"
    sha256                               arm64_sonoma:  "4db600489203ee39c197e8a1cab2b73ff3d55691f744fcb583b17982b1ff78f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e35873dea61e284b285dbe813c0a22e51307f9fd933958504f057fafe180cdf9"
    sha256                               arm64_linux:   "6347b86ef6516b4f755c0009edc9473a64eeac48ce4f5ed2024af33ddf08429e"
    sha256                               x86_64_linux:  "daed27a064ae2e5b9e37d834e1211132b0a524e0f5d7c309e83bc1c96187f8fa"
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
