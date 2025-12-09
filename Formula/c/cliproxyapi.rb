class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.59.tar.gz"
  sha256 "6f3144fedeca1b95fc4437c5c3e284f99510ca1f365fe9a4fc15ad867f207555"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "1b4a61cfe68fd76ca6ae8cad0f1e8f8bd175875eab9cc840ea6c2487ffaae055"
    sha256                               arm64_sequoia: "1b4a61cfe68fd76ca6ae8cad0f1e8f8bd175875eab9cc840ea6c2487ffaae055"
    sha256                               arm64_sonoma:  "1b4a61cfe68fd76ca6ae8cad0f1e8f8bd175875eab9cc840ea6c2487ffaae055"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1b2a7c334d14dd8b860784f4c087a993928af287f809f69cabfce8258956961"
    sha256                               arm64_linux:   "2cad2b6c60c610f2b88578fda99f0cfb7aa6e34f3df35a3d590ea031c2aae28d"
    sha256                               x86_64_linux:  "df98e83c53b3d245239f8f20d4af4e089de76fea8d734532730f31e93cb2aede"
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
