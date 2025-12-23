class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.48.tar.gz"
  sha256 "512ef88ec3e7657937934d56303ba962c83f7368c1465b037ceab3806d89ebc3"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "77aafffe12a556c2043e28167b004113ad84252b1525b98d2adce1ccfd4a980b"
    sha256                               arm64_sequoia: "77aafffe12a556c2043e28167b004113ad84252b1525b98d2adce1ccfd4a980b"
    sha256                               arm64_sonoma:  "77aafffe12a556c2043e28167b004113ad84252b1525b98d2adce1ccfd4a980b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6da06df3e2eade7e570e6bffb1debbe3e25aef31b302cc0ab42745d77912347c"
    sha256                               arm64_linux:   "cb59f7f66cac5d6c31ce59fc3cfbdfca2b0626d2ba42cb38a786cae818bd7324"
    sha256                               x86_64_linux:  "c191e4ed3f2373506a5d98fa26e18593df4201a71ad0e43d71d03a2ef1b88d43"
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
