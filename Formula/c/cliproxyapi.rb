class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.48.tar.gz"
  sha256 "20ed95a621128d34d00bbfb8a178d9f0da31affc303352ef7b248437bbe524a7"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "463c71677514961329822ccc223f115f9f3ecce997dc852be02a5300ed657425"
    sha256                               arm64_sequoia: "463c71677514961329822ccc223f115f9f3ecce997dc852be02a5300ed657425"
    sha256                               arm64_sonoma:  "463c71677514961329822ccc223f115f9f3ecce997dc852be02a5300ed657425"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea1fdd51f313d3836faafb1b0c957b6066da802eae9cb09d75b360e92f437441"
    sha256                               arm64_linux:   "13c1de694a4e3e751575fe67ffc24bd77a1f3fe89da573aecc343065d4c8c50c"
    sha256                               x86_64_linux:  "2292c57cd24f734ec1540f20ee6bb58b008ad2673c88483123e296d7fd4d06a9"
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
