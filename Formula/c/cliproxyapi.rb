class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.54.tar.gz"
  sha256 "267dab81de2f325c58e9f7f841e810ad4b98d1a05a2eab15e35a68b049f400e5"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "d8bc045d43a2b8f0f84e94b6fedef3d677cb65f92a46989ab31647957fc17611"
    sha256                               arm64_sequoia: "d8bc045d43a2b8f0f84e94b6fedef3d677cb65f92a46989ab31647957fc17611"
    sha256                               arm64_sonoma:  "d8bc045d43a2b8f0f84e94b6fedef3d677cb65f92a46989ab31647957fc17611"
    sha256 cellar: :any_skip_relocation, sonoma:        "36f7e010839b03c60bf6c94c7eb23ad42512b3e2654102e191a520da780a859e"
    sha256                               arm64_linux:   "a5544932420d027a9acda2490be493336a1a25653c74c359bad9ef37fb874b32"
    sha256                               x86_64_linux:  "778c1cb98ed4ba4db801ee118cb96a45d86cb1012a001560f7094a930bc9343e"
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
