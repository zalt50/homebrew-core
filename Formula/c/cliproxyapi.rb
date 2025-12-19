class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.33.tar.gz"
  sha256 "55a26e08d241d0c945cc01a781de22b11fa71620d2e41f88841d4309acec484c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "ba955548d0212ead8c85baa90b68d0f80a7637ffd1d97f04bb1b39368290d94f"
    sha256                               arm64_sequoia: "ba955548d0212ead8c85baa90b68d0f80a7637ffd1d97f04bb1b39368290d94f"
    sha256                               arm64_sonoma:  "ba955548d0212ead8c85baa90b68d0f80a7637ffd1d97f04bb1b39368290d94f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d285a96991ad991b4037fd5f69f45ff178e07bac31c2ce7e2550c4e679adece"
    sha256                               arm64_linux:   "7326dd6126b0f96e2e50b91dcd13e5fad7966d490e4abaf0b8ff057b6e7b5f15"
    sha256                               x86_64_linux:  "7af8666eb67f03b7bcae58f20a8d13ea7a0b9dcd9f6d58e00c7d17fa49024cda"
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
