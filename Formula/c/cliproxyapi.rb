class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.33.tar.gz"
  sha256 "55a26e08d241d0c945cc01a781de22b11fa71620d2e41f88841d4309acec484c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "fad10aaa1e016c16cbcb6d5a707253742791186c7d56ba72031dd40089af3d8b"
    sha256                               arm64_sequoia: "fad10aaa1e016c16cbcb6d5a707253742791186c7d56ba72031dd40089af3d8b"
    sha256                               arm64_sonoma:  "fad10aaa1e016c16cbcb6d5a707253742791186c7d56ba72031dd40089af3d8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "505757c2ab2b77db7b80849cad02e6c0ec9378306137996d1868560fabe14034"
    sha256                               arm64_linux:   "9dca38d6ce9b4ea561419338a087aa2c339f7619a0b933800bfc2275992f08b4"
    sha256                               x86_64_linux:  "d927f52f07134c7fa29d9e8718ea3e1738c29e2aeeb3332c039f81f9302072e0"
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
