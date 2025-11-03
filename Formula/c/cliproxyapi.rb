class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.7.tar.gz"
  sha256 "5c6132f19698dd97ff5a3316de461ad244848870eaec7adb707c04a8d6ba9922"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e15d3e955b4e4ea44aafd2751b5152f034b9db811cb682c1435a26f2dd270475"
    sha256                               arm64_sequoia: "e15d3e955b4e4ea44aafd2751b5152f034b9db811cb682c1435a26f2dd270475"
    sha256                               arm64_sonoma:  "e15d3e955b4e4ea44aafd2751b5152f034b9db811cb682c1435a26f2dd270475"
    sha256 cellar: :any_skip_relocation, sonoma:        "4eb00ee8b407ddedbd82c7622210e434d8fe868ba840aa688683d4cfe916c88c"
    sha256                               arm64_linux:   "dd8bb07436dbb3161384e5dbf9ed8b2b946f8012c3f50bea8105f7d6cdfc5c93"
    sha256                               x86_64_linux:  "2c801cd09624bf606476abf39fac103b12f5ff4d42d2099e0bd6c6062b2d0b71"
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
