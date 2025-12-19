class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.29.tar.gz"
  sha256 "5b31482132e6b1a9bf03b193503e30c87dea7dda3e838b10f9f59299c87f7d4e"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "821710dd7d82c6b6ef2d72baf5fd17d8fe40c60d90d300b72de2aa1fb6d5d78a"
    sha256                               arm64_sequoia: "821710dd7d82c6b6ef2d72baf5fd17d8fe40c60d90d300b72de2aa1fb6d5d78a"
    sha256                               arm64_sonoma:  "821710dd7d82c6b6ef2d72baf5fd17d8fe40c60d90d300b72de2aa1fb6d5d78a"
    sha256 cellar: :any_skip_relocation, sonoma:        "385dc659bf2a5dc6dc9b4024df766ffcbdc55089fc25a7ccc20a41587b5b033f"
    sha256                               arm64_linux:   "f483147ef22f0da9ffc60f83735cd8e7b818c2db7c39b0c484057ddf30e2271b"
    sha256                               x86_64_linux:  "1935f6c953a53c5208872d181dfd533a871bfa38c9d321d5ab5c8ea4417f5f0d"
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
