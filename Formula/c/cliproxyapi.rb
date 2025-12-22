class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.42.tar.gz"
  sha256 "87b4eeedd893f8349e7ec6de1bef565c9703826cfe612519f073f08f7d282146"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "d9f20860728b9e125747ebc0b07963e25b34b521b9277f60517674e94f874a03"
    sha256                               arm64_sequoia: "d9f20860728b9e125747ebc0b07963e25b34b521b9277f60517674e94f874a03"
    sha256                               arm64_sonoma:  "d9f20860728b9e125747ebc0b07963e25b34b521b9277f60517674e94f874a03"
    sha256 cellar: :any_skip_relocation, sonoma:        "c87de2ec70cba2e9d9d5e01e513c5544a09afc3b7ab9649dcb81784c51be1d4b"
    sha256                               arm64_linux:   "c52030f224c4d42eabce6e407527f033004a6308e71dc5b21327aa8a2dbd0e34"
    sha256                               x86_64_linux:  "5b3afebb5377a2a12dcef10bde8b897ab348b52030eebcf20b9e8afe5a5676a9"
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
