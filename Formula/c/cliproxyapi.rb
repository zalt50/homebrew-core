class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.21.tar.gz"
  sha256 "fbf707049f1d576e86e75498f7bf61d66a5eff387c958a510fdd8c8caf5f856b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "f498fe2be10a2f4eb0983381ee22ed624e62f1f8d91d90e8fe3af3477ba65823"
    sha256                               arm64_sequoia: "f498fe2be10a2f4eb0983381ee22ed624e62f1f8d91d90e8fe3af3477ba65823"
    sha256                               arm64_sonoma:  "f498fe2be10a2f4eb0983381ee22ed624e62f1f8d91d90e8fe3af3477ba65823"
    sha256 cellar: :any_skip_relocation, sonoma:        "28d1e4875cc02c48a3f94ae2e7338c691c825fd150acfedfe5641040fb2d7b16"
    sha256                               arm64_linux:   "c2b008878f1b707872bdbf39ac991845422e18b1b98af51d65852432cb3159a2"
    sha256                               x86_64_linux:  "6491bcc2fb841b6d22fb56948082d82c30c4539b97e69cb51f66652ea125066f"
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
