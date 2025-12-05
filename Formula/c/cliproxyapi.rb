class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.44.tar.gz"
  sha256 "fb48d0bd9402bcaea505d07bc49910f60e1ef159599a5a5ad373c7bf3e01f439"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b82ee8d60ee4c9aaa207aba1405988c64cb6eeccc147c12116109a245e54af05"
    sha256                               arm64_sequoia: "b82ee8d60ee4c9aaa207aba1405988c64cb6eeccc147c12116109a245e54af05"
    sha256                               arm64_sonoma:  "b82ee8d60ee4c9aaa207aba1405988c64cb6eeccc147c12116109a245e54af05"
    sha256 cellar: :any_skip_relocation, sonoma:        "9309d2ca9fbd923c02e74dcb676c07c99b6fdc4abd6bfe6b473edd20ed1abdab"
    sha256                               arm64_linux:   "ef0a96786cac5986b3340d4514228ec26e7bd424ff4922fb7fae663b38e1b1e1"
    sha256                               x86_64_linux:  "aa80e360e8764de118babd74273bdee7fa2088bff4907549b85bbd6e3cbf915f"
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
