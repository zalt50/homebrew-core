class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.8.tar.gz"
  sha256 "6ec59be1c0cc7d77d4bbb1b7c2c0ec7ebdb37072f886d5a2373fd2f46c129f64"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b7df8c3c6de81e20ba0b3cf7e00aa2648ada96630703de91fe948d0d7a085821"
    sha256                               arm64_sequoia: "b7df8c3c6de81e20ba0b3cf7e00aa2648ada96630703de91fe948d0d7a085821"
    sha256                               arm64_sonoma:  "b7df8c3c6de81e20ba0b3cf7e00aa2648ada96630703de91fe948d0d7a085821"
    sha256 cellar: :any_skip_relocation, sonoma:        "12a636b8642d60a4b04d6b94857d556ab4662e41346c2a507a2cbb80e96444c8"
    sha256                               arm64_linux:   "b71bc0add8dec9f5d0c57f402dfca2459a9009a7d4eb121737874be1afb5695f"
    sha256                               x86_64_linux:  "67df8b53741fd97f5428477f16829bc84f1d684721d974bd127123f29e445038"
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
