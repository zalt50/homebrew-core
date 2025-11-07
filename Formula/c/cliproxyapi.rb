class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.12.tar.gz"
  sha256 "97265b5add42f994043ea57b8d3d317faecdef73e3544a53c96850b61d856b54"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "6f95ca4145f22cb3234c30d3c95ae8bbf7fb8fda346d8f6c26be5e8fedcbadb0"
    sha256                               arm64_sequoia: "6f95ca4145f22cb3234c30d3c95ae8bbf7fb8fda346d8f6c26be5e8fedcbadb0"
    sha256                               arm64_sonoma:  "6f95ca4145f22cb3234c30d3c95ae8bbf7fb8fda346d8f6c26be5e8fedcbadb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a7266c48619d361b70bfc80f2c1953c80540278b1bf425b014ecb5979b1e2da"
    sha256                               arm64_linux:   "095eaaf050db5c54c040bb7cee27f8dc94bd242ed11b3e8429ee7bd1ab974b5f"
    sha256                               x86_64_linux:  "b7f0846bff150d079c9ffc23b37e13b8e3211b3e37d563bb57824b4a06d877c4"
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
