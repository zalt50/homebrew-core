class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.13.tar.gz"
  sha256 "444a4807513fead7da102ed9b6d412ad4a11a8f7474537f17f10fee80d622765"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "5c76754243b3e4ffecc83ae89316be8f3dcbf237d52f0eb15a1674339cd48810"
    sha256                               arm64_sequoia: "5c76754243b3e4ffecc83ae89316be8f3dcbf237d52f0eb15a1674339cd48810"
    sha256                               arm64_sonoma:  "5c76754243b3e4ffecc83ae89316be8f3dcbf237d52f0eb15a1674339cd48810"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb02548b0241634480becbc3029c0a40c79bf6fce1037fe537e4f1891b2db6ee"
    sha256                               arm64_linux:   "7b27ec85c622e1c9370d47bd1ad876504c04dceeaeaac977dea9961b8db9a155"
    sha256                               x86_64_linux:  "d4ee13b2630bf147817ad5a03b5e7b8770f8bb87274ecf006861eef25a57fd5d"
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
