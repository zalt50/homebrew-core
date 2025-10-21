class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.28.tar.gz"
  sha256 "cd73f9153f87e7c2cad1a3b0d06c54ac436d633405a9e04a230b006bbe03946e"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "5fbed13373168cf34533b6ce5c19e762bc33a3785a586247c1b42416b16e46e0"
    sha256                               arm64_sequoia: "5fbed13373168cf34533b6ce5c19e762bc33a3785a586247c1b42416b16e46e0"
    sha256                               arm64_sonoma:  "5fbed13373168cf34533b6ce5c19e762bc33a3785a586247c1b42416b16e46e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "aeee72e296a00b8b1c545bcb5c176976313cabd9d00a9369970029fae2710656"
    sha256                               arm64_linux:   "c102ce2ed767cd145f57588ee903032f52623b15a5cd69b975883cac0292e554"
    sha256                               x86_64_linux:  "39ec5a39dc929df39abd88f0ca58621d355ba97d75e0ff996051057f25e5d4b1"
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
