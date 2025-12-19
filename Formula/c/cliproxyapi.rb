class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.32.tar.gz"
  sha256 "b4fcf191dba246f1e00876b9d7827481cd0bec43726621fb11661566b830cb90"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "7f0e5dec8c49f33f1b15af2af54bbd10f8a39b21e0f1da53e65f483009760b70"
    sha256                               arm64_sequoia: "7f0e5dec8c49f33f1b15af2af54bbd10f8a39b21e0f1da53e65f483009760b70"
    sha256                               arm64_sonoma:  "7f0e5dec8c49f33f1b15af2af54bbd10f8a39b21e0f1da53e65f483009760b70"
    sha256 cellar: :any_skip_relocation, sonoma:        "74d3b3d2d157b0f68573f524ba4a8f0cf38465d711fb29f4a15596aa37a5abc4"
    sha256                               arm64_linux:   "d891e924b310f5c7665f58269661e57a2fe68f2c05d126df3ec2df30c91f5358"
    sha256                               x86_64_linux:  "7c82224eb24165d1a6723f283346923b61cd6cf1e02b401dcd8d177680d64207"
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
