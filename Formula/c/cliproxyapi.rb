class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.23.tar.gz"
  sha256 "7f427377bfdb448a5ca290e4b6f75e2598a8ae14fdc060ab42f78f4af7a67b53"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "2426ba559f308a3e0f5035e4ad83d5ea8d5f192ecf7e6ff2bc5413f7b6d6c30f"
    sha256                               arm64_sequoia: "2426ba559f308a3e0f5035e4ad83d5ea8d5f192ecf7e6ff2bc5413f7b6d6c30f"
    sha256                               arm64_sonoma:  "2426ba559f308a3e0f5035e4ad83d5ea8d5f192ecf7e6ff2bc5413f7b6d6c30f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e64ac682ebb0841d4cdaeb6616c56d52d2e6d27c799185ac7d359aef096fadf"
    sha256                               arm64_linux:   "65d946dbc9fe5137f3612eec436023095e41cf10b8ff33e384d1a37f36c6fa5d"
    sha256                               x86_64_linux:  "5025710020d59490e8f20fde81958daeaa393ab6ff84b9e2f5f4b0f2fbbc681b"
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
