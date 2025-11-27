class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.25.tar.gz"
  sha256 "4e0dc450b9172e2fd5820bb70b9176f0bafd86dd5d1f58088b82f81ccd29d1f1"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "20b31a768496b0782148f474ee1d625a924e10102b70d5d6ea289e106bdf91a0"
    sha256                               arm64_sequoia: "20b31a768496b0782148f474ee1d625a924e10102b70d5d6ea289e106bdf91a0"
    sha256                               arm64_sonoma:  "20b31a768496b0782148f474ee1d625a924e10102b70d5d6ea289e106bdf91a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9839d44201072ff1c3ba20bd1bf4b5351557287e1000518cb46447ae2f8d28ca"
    sha256                               arm64_linux:   "39060153fb222496935af6f9d18b87ad3184c0bf177109f42458527b78d62863"
    sha256                               x86_64_linux:  "c6bf2ad2cd88d5af57a51056fdbf22482cf5052f6f3aad4b90db63cce3cbf9ae"
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
