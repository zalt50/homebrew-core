class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.48.tar.gz"
  sha256 "20ed95a621128d34d00bbfb8a178d9f0da31affc303352ef7b248437bbe524a7"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "2546318940ac5c2f36674d4ab1f253a994655f6b42a052ece9ae7acbaaafd9cb"
    sha256                               arm64_sequoia: "2546318940ac5c2f36674d4ab1f253a994655f6b42a052ece9ae7acbaaafd9cb"
    sha256                               arm64_sonoma:  "2546318940ac5c2f36674d4ab1f253a994655f6b42a052ece9ae7acbaaafd9cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5e6219ad8c00e48736c9b2119f742e656c7a1838778d1bd2b19f0e79f7db7aa"
    sha256                               arm64_linux:   "5454c8744300caaa4f5b3ce00d0d8503f4b133fe92ac360f3f430e61ee140484"
    sha256                               x86_64_linux:  "0dafbf0d2f1c0ccc01e9108eb68b141d9efec97b88eaa59653788a929cc70a4c"
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
