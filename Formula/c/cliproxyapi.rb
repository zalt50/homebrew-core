class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.38.tar.gz"
  sha256 "69bafdbae304ceaf73e5da3c1a50b4ecd3879d148f7705af23335bff0bb5bfb9"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "85b4a2543cefa9426c87212dff07ac2d4a1a7584c6eaefb7d771719c5da03621"
    sha256                               arm64_sequoia: "85b4a2543cefa9426c87212dff07ac2d4a1a7584c6eaefb7d771719c5da03621"
    sha256                               arm64_sonoma:  "85b4a2543cefa9426c87212dff07ac2d4a1a7584c6eaefb7d771719c5da03621"
    sha256 cellar: :any_skip_relocation, sonoma:        "0078e7eaaa7dbd8aeb803b3b510ff0331e1b541dab94a39be05f5305993a3c08"
    sha256                               arm64_linux:   "506f529906a85f28cb4ea85b814221bfe254852ce9172486e6c504b1777308f2"
    sha256                               x86_64_linux:  "e7d9714b9d51ebf8e5a79c40503f35b57d6fcca58b74d5a62c0890b4446e91cb"
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
