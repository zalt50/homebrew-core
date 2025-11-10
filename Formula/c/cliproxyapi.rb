class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.26.tar.gz"
  sha256 "a8997491f3f44e877f55c5702874904cd44d1caeffd431b0bbed75661f22d5ab"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "2cbdf0756d18444960f568c4eb2d115facfe66c4615234c46b62144d3c93ebe4"
    sha256                               arm64_sequoia: "2cbdf0756d18444960f568c4eb2d115facfe66c4615234c46b62144d3c93ebe4"
    sha256                               arm64_sonoma:  "2cbdf0756d18444960f568c4eb2d115facfe66c4615234c46b62144d3c93ebe4"
    sha256 cellar: :any_skip_relocation, sonoma:        "32edcd9d49f47bf47fb1845699a51139433e3950d2a6edb59f4d3dffb07f4647"
    sha256                               arm64_linux:   "d49ae24bf105b19d4f65daa5d1c2c903aaa0879303165a096064e756514de357"
    sha256                               x86_64_linux:  "e6054ec0c6ed4debd216d7fa630be0051c8e426786b6e760cb9f04bfcf2ed2ff"
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
