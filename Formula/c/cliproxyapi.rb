class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.18.tar.gz"
  sha256 "6807314a2cf9f2be73c79b198347ad3fdb101b0d5850385c19c942bd22d7739f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "af7969eac33c2d6ab7792a0e156272ff9c73d47db99c0b920a6bbf372c7d197e"
    sha256                               arm64_sequoia: "af7969eac33c2d6ab7792a0e156272ff9c73d47db99c0b920a6bbf372c7d197e"
    sha256                               arm64_sonoma:  "af7969eac33c2d6ab7792a0e156272ff9c73d47db99c0b920a6bbf372c7d197e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b54c409a22b92fa76724618b6922feb4dffcaa2cb1dbcc1a5afa814c67d0e8a7"
    sha256                               arm64_linux:   "fc33d785da58ef3bf20b2ad6775eb0977003dad2e9934eff6cebcfcd1b6907ad"
    sha256                               x86_64_linux:  "2173c0a7cb9daf37d665a42c8473fd68bf328a977cb6aa6b39259403a120d656"
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
