class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.8.45.tar.gz"
  sha256 "3019c549cf85f1964998c4a7933ffafea0b293ea060f29427b3381480fb82b9d"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "8f72bccc9993bda4b1d30d470c1d9226749fd6199b0a3d637ad757e6cb48a48f"
    sha256 arm64_sequoia: "8f72bccc9993bda4b1d30d470c1d9226749fd6199b0a3d637ad757e6cb48a48f"
    sha256 arm64_sonoma:  "8f72bccc9993bda4b1d30d470c1d9226749fd6199b0a3d637ad757e6cb48a48f"
    sha256 sonoma:        "6cb40dfe55efc6bb3fd5ca14450fe722c933aec0c6f45b3fd912d67045f95b7c"
    sha256 arm64_linux:   "6a0e7fd726a6d025e52cee1b66949337b770ebf82497c5961c3577152f111f61"
    sha256 x86_64_linux:  "cc1f35821aa78b2a2198d2f76d1117184da258686218f7e19b870eedf8246f9c"
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
