class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.7.tar.gz"
  sha256 "1775b9770c15821e233f78ed7863739b6c2a417f5a16f67394815cd496fbd3d4"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "4995aab312884e6467e978cfd946c5963921919e60854fc0d1a7c47bcbe1bc42"
    sha256                               arm64_sequoia: "4995aab312884e6467e978cfd946c5963921919e60854fc0d1a7c47bcbe1bc42"
    sha256                               arm64_sonoma:  "4995aab312884e6467e978cfd946c5963921919e60854fc0d1a7c47bcbe1bc42"
    sha256 cellar: :any_skip_relocation, sonoma:        "242d70c8a1a98b3fd5e220a17fbf662605dfa3e8a4d7cdd45c70330e11b5126f"
    sha256                               arm64_linux:   "98d1c5eaed15e6e6b0fefcf3a6ecc3af7c1249e92fba3a778d8f3b0210bda978"
    sha256                               x86_64_linux:  "916eeede11930c1c1e0769bec764edcb0b42132179e95ca13292a601414de0fa"
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
