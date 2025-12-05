class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.46.tar.gz"
  sha256 "77ff85d3e8bbd3fdda39dd545f6d51cece3cd3172624d42dde9b92519de1fde1"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "f56563d1f1f6e2b5afe7bc5667220bccbedfacb7e34a10840216f2685c96e469"
    sha256                               arm64_sequoia: "f56563d1f1f6e2b5afe7bc5667220bccbedfacb7e34a10840216f2685c96e469"
    sha256                               arm64_sonoma:  "f56563d1f1f6e2b5afe7bc5667220bccbedfacb7e34a10840216f2685c96e469"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ebf48dd9b5cb88cf25f75200ff77efa18ba43cc70546feca62476428407ee20"
    sha256                               arm64_linux:   "139d591eda6a209ae7c2cd6626df15068cdccdd4dbb1fab6f48de76131d4edeb"
    sha256                               x86_64_linux:  "3708591227fb19452fda644fb7a62a8a1bb3e1e985d912a2b95ade369085a1af"
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
