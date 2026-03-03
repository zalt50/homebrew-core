class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.8.40.tar.gz"
  sha256 "f9376aca4c45c4b0642a9e3ef45e5a94ea08f39252357d5698456434aa9c9858"
  license "MIT"
  head "https://github.com/router-for-me/CLIProxyAPI.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 arm64_tahoe:   "e39af14f11ce6b160e6b9b970ed9f9aff5e37c826d06401003a2bb6ad5302a70"
    sha256 arm64_sequoia: "e39af14f11ce6b160e6b9b970ed9f9aff5e37c826d06401003a2bb6ad5302a70"
    sha256 arm64_sonoma:  "e39af14f11ce6b160e6b9b970ed9f9aff5e37c826d06401003a2bb6ad5302a70"
    sha256 sonoma:        "aafc5eee0ead6a6531dca4a20ac36b36fd4e0e0898d9d9733a54290c390afb0b"
    sha256 arm64_linux:   "52a726e083d712251a210a74394b105cad56db5502b8efc87119c9b40b0055e8"
    sha256 x86_64_linux:  "83260b49ffb68feab4ebba58f125309fdc9d2003e9c38aa0fc0925fe0e072cf7"
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
