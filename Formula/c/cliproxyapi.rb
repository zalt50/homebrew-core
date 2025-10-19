class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.23.tar.gz"
  sha256 "39c21e7cf0615f8a5b71cff8b5687bd7a52ed5818aacfde12011b305ec5d379b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "44955082a879e10f380201e261c2e19efb10c936aaf8d2df05edf7d5ace86322"
    sha256                               arm64_sequoia: "44955082a879e10f380201e261c2e19efb10c936aaf8d2df05edf7d5ace86322"
    sha256                               arm64_sonoma:  "44955082a879e10f380201e261c2e19efb10c936aaf8d2df05edf7d5ace86322"
    sha256 cellar: :any_skip_relocation, sonoma:        "38a6fafda2fdf725adb841995a62fbc3f8582efbbe4b5182b944a431ba51fa87"
    sha256                               arm64_linux:   "b3360001bf84a2121ba70538bb4f2eca04dbfddcf3a0a2fdab0adb700d40fc29"
    sha256                               x86_64_linux:  "e9cc84dcd0acb84368d2d883f73d7ff882d64626d6abb401b13e761963c4e0a4"
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
