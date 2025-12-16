class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.19.tar.gz"
  sha256 "5cf65410a75f2ada6d98f15b92b447fda082ec1d2c6487aef957b25244413096"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "98c0c8105a2827ae61d8028e542cbb09c9c5a72adac28f8116edeba115a979d8"
    sha256                               arm64_sequoia: "98c0c8105a2827ae61d8028e542cbb09c9c5a72adac28f8116edeba115a979d8"
    sha256                               arm64_sonoma:  "98c0c8105a2827ae61d8028e542cbb09c9c5a72adac28f8116edeba115a979d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e9c30c2d337a7d3365a21c614b8de8b9eddaf20e7a3ccee7f8d21e19c297c9f"
    sha256                               arm64_linux:   "cc19a3029b1c13fb6039d530d865c7a809d09388a72706fa816bd9468e737df4"
    sha256                               x86_64_linux:  "bb521040b4e9e8e43111b0aeed9c197717f8a3a6d8fb726d365af92ecb215a58"
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
