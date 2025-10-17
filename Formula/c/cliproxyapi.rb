class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.20.tar.gz"
  sha256 "f544043cafd5580db258659453941a947ce05e75127d8118d0b53dbe05b9e390"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "3ba306f903a114c737a5a2d0d5523aeeace00404b6ab911e4ad74aa0157d0f2e"
    sha256                               arm64_sequoia: "3ba306f903a114c737a5a2d0d5523aeeace00404b6ab911e4ad74aa0157d0f2e"
    sha256                               arm64_sonoma:  "3ba306f903a114c737a5a2d0d5523aeeace00404b6ab911e4ad74aa0157d0f2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a4d55f8f2fcbc798150dc10e60a126505e9502193690bb3ce38565f35c6a478"
    sha256                               arm64_linux:   "77f9aab887b3b2405c8c1fbd69c87c23a5d4903db654353927e9460f3a5fd367"
    sha256                               x86_64_linux:  "2445667e2c7af16ba59ebe2acd67963e70c348f1af2a5c33044cb25079c75f91"
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
