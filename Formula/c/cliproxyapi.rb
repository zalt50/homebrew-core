class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.42.tar.gz"
  sha256 "7e9cdf0e5f3e9a9bd5619345bfc803d2dac752c23e57de16db954e5076a22221"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "3e61ab2ae3cde5b9da6eea390e560a0093ee664deeaa6545a54765a8f49586f5"
    sha256                               arm64_sequoia: "3e61ab2ae3cde5b9da6eea390e560a0093ee664deeaa6545a54765a8f49586f5"
    sha256                               arm64_sonoma:  "3e61ab2ae3cde5b9da6eea390e560a0093ee664deeaa6545a54765a8f49586f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dd498174a946eb3ffc15b694b3b96960992848e4aa95b33d9cb253d97b63518"
    sha256                               arm64_linux:   "01b0577c87bc5ab837da9af4dbbc35aec758dffb5ce8eda1bf97f668b8719f3f"
    sha256                               x86_64_linux:  "287d4a44096419a4a729616fbad31547793ab5f8059e8088dcfa59e0b3c1a50f"
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
