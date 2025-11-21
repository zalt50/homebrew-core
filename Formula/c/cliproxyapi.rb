class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.1.tar.gz"
  sha256 "9c23f08d9d004d402aecd9bbdd6079e58eabc59262111f4b6d1c34ef23708855"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "9591fa841ae2d061dc68732f0e332e02cd33badcdec496766f8ca896538f6f8d"
    sha256                               arm64_sequoia: "9591fa841ae2d061dc68732f0e332e02cd33badcdec496766f8ca896538f6f8d"
    sha256                               arm64_sonoma:  "9591fa841ae2d061dc68732f0e332e02cd33badcdec496766f8ca896538f6f8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cb80946b245542335a36cd059252e2f2af92f9248fef378b32f4988139f6fea"
    sha256                               arm64_linux:   "c16c0136410f954eaa8314212b77ee5fe1ce501d8ee1637fc204b922808421b2"
    sha256                               x86_64_linux:  "8f13b7b744d6ab2fbada21a9b339620deacde314b29a82c4f973bb216cb3d475"
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
