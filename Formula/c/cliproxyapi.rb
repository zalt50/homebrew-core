class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.53.tar.gz"
  sha256 "70e9b176ca18b348451fe2dfeb3d9adf433806f58b4635ef2d788b4338538bc7"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "90b3d35b8996401f928ff86bc0f69f9f6561d911f3bcfdd9b617ad826327b581"
    sha256                               arm64_sequoia: "90b3d35b8996401f928ff86bc0f69f9f6561d911f3bcfdd9b617ad826327b581"
    sha256                               arm64_sonoma:  "90b3d35b8996401f928ff86bc0f69f9f6561d911f3bcfdd9b617ad826327b581"
    sha256 cellar: :any_skip_relocation, sonoma:        "69539a5cd06b57ac9b5a687316f6c2112ea56268ce41c1085e9a6da29fa36f6b"
    sha256                               arm64_linux:   "c32484f4c0c56762ab8a9891fe37cb71e264e23b44b0346d65eeeba12f665cb1"
    sha256                               x86_64_linux:  "83d7e949cfb6c7c17d4eb3a1c91280179ee53ff4b173f88ce0dc312e8d387eff"
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
