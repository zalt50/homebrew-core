class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.57.tar.gz"
  sha256 "83b5ddb7097b30924a5620a5f242a15fc8f3097d6bf0c7235ec50872efca780a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b3f33eeaa10915eec7c60e33aaeaf4b17bbadb38b973e6d46bc7bc97fdd96035"
    sha256                               arm64_sequoia: "b3f33eeaa10915eec7c60e33aaeaf4b17bbadb38b973e6d46bc7bc97fdd96035"
    sha256                               arm64_sonoma:  "b3f33eeaa10915eec7c60e33aaeaf4b17bbadb38b973e6d46bc7bc97fdd96035"
    sha256 cellar: :any_skip_relocation, sonoma:        "16268dd428b96caa3ea741358cb4629fd12119434b8cba8bbd47f9453ed88f75"
    sha256                               arm64_linux:   "bcd0daa711a8b5c2a2af37f4c6076d94a5e17c0a1d54e66711749e14ba147499"
    sha256                               x86_64_linux:  "ed9254b9829e0169ed60765a9724751389ca579745bbbf051407ffb2cba8326f"
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
