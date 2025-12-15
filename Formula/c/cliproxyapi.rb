class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.16.tar.gz"
  sha256 "0e5363a07dd4cd88ed6a35ec89dedfae812314e9aaa0e76b694ac23b0b99db49"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "beae650b6ef732f23bca68a717c458f05d84dcee7458f12106beb69742bcf142"
    sha256                               arm64_sequoia: "beae650b6ef732f23bca68a717c458f05d84dcee7458f12106beb69742bcf142"
    sha256                               arm64_sonoma:  "beae650b6ef732f23bca68a717c458f05d84dcee7458f12106beb69742bcf142"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d6917189e947de5657b2d3d04389b20c304daf70a7a2c4334017e1ea2f99cf5"
    sha256                               arm64_linux:   "09ad52cb56828e883ef0e8ccb4fd8354b0c23bb787ad3459f7bacf05c85835d7"
    sha256                               x86_64_linux:  "d3fba2afcc8651ba13a7fb3be4dc499f655375659fbf27592403715623a24f7b"
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
