class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.41.tar.gz"
  sha256 "5201fb424eb533f240b210e55ef86e6d1476eaff277a08fc081c8e6d0e57128c"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e423612951c44a8894f0a587f3b1bfaa4608c53d579100ff97f97afa487597dc"
    sha256                               arm64_sequoia: "e423612951c44a8894f0a587f3b1bfaa4608c53d579100ff97f97afa487597dc"
    sha256                               arm64_sonoma:  "e423612951c44a8894f0a587f3b1bfaa4608c53d579100ff97f97afa487597dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "73bf3c8f56aea6dea022c5d5816dc8b81b7a5124c3ee363d4a76174e4b407e54"
    sha256                               arm64_linux:   "1e6b42b33c5ad53429e4ce5334b83cf7ba6de76910bd1fdb1cb7fa23533d7e1b"
    sha256                               x86_64_linux:  "2e9cd33f0f379e7543b35d569c25bd7f123af1f30f5d34d697cfddfb45327765"
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
