class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.18.tar.gz"
  sha256 "27cd03f8d5124d9dae5d8640c96942a39dd57b847354213ab42ed617d4e1b520"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "d0fd042aceced384c40b9fff934a0e5f089f3cfb376e6531fbed82fdc113bf2b"
    sha256                               arm64_sequoia: "d0fd042aceced384c40b9fff934a0e5f089f3cfb376e6531fbed82fdc113bf2b"
    sha256                               arm64_sonoma:  "d0fd042aceced384c40b9fff934a0e5f089f3cfb376e6531fbed82fdc113bf2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bb1ba4a0e93cbd1060cec007800475129bc2885e3a9406bf7d88f76a7f5e4f1"
    sha256                               arm64_linux:   "1f39a038eb6d9253887aec0537c00caadf6cb648949f83aa6d0d16d2dd5616e1"
    sha256                               x86_64_linux:  "746be40779c4272884b5eda1e37aa376e6f92aec7ba0bcca4668a56c8801b235"
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
