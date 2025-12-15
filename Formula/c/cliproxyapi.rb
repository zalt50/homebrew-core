class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.16.tar.gz"
  sha256 "0e5363a07dd4cd88ed6a35ec89dedfae812314e9aaa0e76b694ac23b0b99db49"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "30a2dcc10125abb5c554615fc000d1c87b1aedeb86ebfaad0f3a0c7a5457da1a"
    sha256                               arm64_sequoia: "30a2dcc10125abb5c554615fc000d1c87b1aedeb86ebfaad0f3a0c7a5457da1a"
    sha256                               arm64_sonoma:  "30a2dcc10125abb5c554615fc000d1c87b1aedeb86ebfaad0f3a0c7a5457da1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "bad693d544221efc740af7686692b58d5f24beac8f3ea68939fe2ab9fa359336"
    sha256                               arm64_linux:   "1bb80dc2c002005994edc2c4aff84e7fd3fd24af37013e7ccc18c07016a68713"
    sha256                               x86_64_linux:  "0693728a86ece8e8746e31d69ed4ba15a4bf19bf3c67fd46a42c121725b724eb"
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
