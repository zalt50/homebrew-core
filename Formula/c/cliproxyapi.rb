class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.30.tar.gz"
  sha256 "f4211ff3b42fcde960a46a4dd8f551ea38cc901a551ec5a022ba5924e902d416"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "9697c2aed6c2383373054b539508fac13d0a9a5a06c47c14c6d8a98d5bf132db"
    sha256                               arm64_sequoia: "9697c2aed6c2383373054b539508fac13d0a9a5a06c47c14c6d8a98d5bf132db"
    sha256                               arm64_sonoma:  "9697c2aed6c2383373054b539508fac13d0a9a5a06c47c14c6d8a98d5bf132db"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f942e7f1890e0099f1658d27f44976e645f4a6b2f6260fa4929382347bd76f0"
    sha256                               arm64_linux:   "9417b33299a2bafa1918081ab4cce855d38d75bbeafcb73c21446e88c5c736d1"
    sha256                               x86_64_linux:  "389880c64662ce39bf098360611a4f06c4be2f94cb7340dd5bcf924949129196"
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
