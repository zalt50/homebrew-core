class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.37.tar.gz"
  sha256 "762d642abc406599be3207992eba6dd2bc21a4776232674f397cf1210159332a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "1bc3e92cd8c37478abf259171cffb55ed029a48fb2fcfc73cfee89c030efbeb5"
    sha256                               arm64_sequoia: "1bc3e92cd8c37478abf259171cffb55ed029a48fb2fcfc73cfee89c030efbeb5"
    sha256                               arm64_sonoma:  "1bc3e92cd8c37478abf259171cffb55ed029a48fb2fcfc73cfee89c030efbeb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bf6a64d59ea43d3ccd91ab3194129cee02c0485d47d69e05b483fd44a76d443"
    sha256                               arm64_linux:   "f76b5342dad2735dce7f1aed583bf5a07726d9f49e02253d4c2980abf0bb0404"
    sha256                               x86_64_linux:  "bc6b45725b624db9c0b2e773b60a8d4247c02a583e89193464221a230efb9c63"
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
