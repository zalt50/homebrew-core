class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.13.tar.gz"
  sha256 "ce5df83e1ad3ef0b22966e196020356dd751972a351e96f6466b63de11a6666a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "567800a3380f4e15ddf0fd2b467a15920880a4164834e05cb738d7e13fbbfc24"
    sha256                               arm64_sequoia: "567800a3380f4e15ddf0fd2b467a15920880a4164834e05cb738d7e13fbbfc24"
    sha256                               arm64_sonoma:  "567800a3380f4e15ddf0fd2b467a15920880a4164834e05cb738d7e13fbbfc24"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b4c9738d052c7a5431e96ff08ef6f9654ba86fd39da01c42329e9f98b67d648"
    sha256                               arm64_linux:   "816b70d156dc76cfdecf961ba83148f0ae490a61151f0388ea0adbf416a476e4"
    sha256                               x86_64_linux:  "0819e8abb0d2bd33209dec0f55204ad898e31625642e38ce51af6de996df5c6a"
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
