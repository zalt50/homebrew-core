class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.11.tar.gz"
  sha256 "124bf83564af6b9e644d55216d44ff1f35f32e0e2f0f8f753276b6f4d66a1322"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "18acbc354f48989837d118cf2aad57c4eb6fcb511b7258aa698b8cacf1be3eda"
    sha256                               arm64_sequoia: "18acbc354f48989837d118cf2aad57c4eb6fcb511b7258aa698b8cacf1be3eda"
    sha256                               arm64_sonoma:  "18acbc354f48989837d118cf2aad57c4eb6fcb511b7258aa698b8cacf1be3eda"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cbd8b50e81f0176082a6a43b9e8a94ef4d3dffaa5facd88eb7f2934870a3979"
    sha256                               arm64_linux:   "f921eaccac4d69f6ade805682e45463bba6c360c097b732fedad39811b3c6e76"
    sha256                               x86_64_linux:  "6f0967cbfbf15dc1a0912a1044be2aeb162275af09cc078f24ccdaecc2f8683a"
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
