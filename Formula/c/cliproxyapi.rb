class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.22.tar.gz"
  sha256 "e3b224c7c55ec63bc866ef69b4a2e13fd0219da1bd555064a84fbd3eb9319f4f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "675db37936f4b60d39b1a1532ee443ed1f21b1096c07e77107f145495a16703d"
    sha256                               arm64_sequoia: "675db37936f4b60d39b1a1532ee443ed1f21b1096c07e77107f145495a16703d"
    sha256                               arm64_sonoma:  "675db37936f4b60d39b1a1532ee443ed1f21b1096c07e77107f145495a16703d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c58a7ca0de79c6699acf38315b08edeb55a4f2177b59018602ff32f5a6ee6fd0"
    sha256                               arm64_linux:   "572c28468db0f4033ba9c184fbb8265a0ea146e005dfade6ab7eb29a47327fab"
    sha256                               x86_64_linux:  "8cf2f5c99542a0a32227d3c2a66a0def9cf6b227f36c0adc2c77460e414285a4"
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
