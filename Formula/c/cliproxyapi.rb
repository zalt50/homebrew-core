class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.22.tar.gz"
  sha256 "cc05c5707a49c6444dccd9e2a1b084f782c5ce7c7cfef2a7cd77d65b58ca4ab1"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a776b630eb874f9eed98df991cd29054c3c1df1c10da93163279dd9a801f37e4"
    sha256                               arm64_sequoia: "a776b630eb874f9eed98df991cd29054c3c1df1c10da93163279dd9a801f37e4"
    sha256                               arm64_sonoma:  "a776b630eb874f9eed98df991cd29054c3c1df1c10da93163279dd9a801f37e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4621ea47691ef51d1bb0d7e84d2c16436071c100227893bb8fae692daa432728"
    sha256                               arm64_linux:   "fc897239bd048f2633a433ef80d668584bca717c152e5142e38c133e44885e5a"
    sha256                               x86_64_linux:  "82efb6108cdf57e86e580e04b02c5ce75c411ce855eb182a0f4bff8896674aa9"
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
