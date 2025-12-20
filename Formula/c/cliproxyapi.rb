class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.38.tar.gz"
  sha256 "eee046b5635942bd77f1bb1c690639518fbaf14820bc593ea3e260a8b411ea39"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "b015b50a9af9a9dad0a48f3b327059143ecc760dfba14d8589edd9856b4bc99f"
    sha256                               arm64_sequoia: "b015b50a9af9a9dad0a48f3b327059143ecc760dfba14d8589edd9856b4bc99f"
    sha256                               arm64_sonoma:  "b015b50a9af9a9dad0a48f3b327059143ecc760dfba14d8589edd9856b4bc99f"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb7e2dc33e8db847005b8e5fa7949dcbe5245d1b76b253322adb9748b813b8f6"
    sha256                               arm64_linux:   "3edba4157090134b329b2104c251f3b2931f5d09fcd018d1c28236c5d7ecd06c"
    sha256                               x86_64_linux:  "01c9a3fa5a6396e0996545d18ae6680df16d23b6d0b7c92791dbd37accda39f5"
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
