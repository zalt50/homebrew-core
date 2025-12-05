class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.44.tar.gz"
  sha256 "fb48d0bd9402bcaea505d07bc49910f60e1ef159599a5a5ad373c7bf3e01f439"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a05a6faee14cc8d3871ea49906f140d6ee6c5c39d42e20938b0af25b837f6fb9"
    sha256                               arm64_sequoia: "a05a6faee14cc8d3871ea49906f140d6ee6c5c39d42e20938b0af25b837f6fb9"
    sha256                               arm64_sonoma:  "a05a6faee14cc8d3871ea49906f140d6ee6c5c39d42e20938b0af25b837f6fb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d7b17cd2bc7ef7850e3d32dcb15348fec99fdb7c06ce98eb714b86f25d222ec"
    sha256                               arm64_linux:   "7d38b59835a4ea843f1c82455c44d3b4675e013d68224aa8480017634f4afdcb"
    sha256                               x86_64_linux:  "05a5917e9bb96c8c233ae97818465fe318ca78e22940255f5413b6fa1591c456"
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
