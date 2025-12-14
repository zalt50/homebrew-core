class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.11.tar.gz"
  sha256 "d168d261e9a98b52b5869680a145f7aabbf87edf60ead759218e7ad54cd29314"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "f5c8ec02f0b12da4ea9cc6a9e751ff13a095cc89d08e391a1106130228e8772f"
    sha256                               arm64_sequoia: "f5c8ec02f0b12da4ea9cc6a9e751ff13a095cc89d08e391a1106130228e8772f"
    sha256                               arm64_sonoma:  "f5c8ec02f0b12da4ea9cc6a9e751ff13a095cc89d08e391a1106130228e8772f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b938481b34ebb3b1ebcf71eebb013a00eccc55c85b7ee12d007fe5b26bd6b802"
    sha256                               arm64_linux:   "5122642fe984f88015c9e96f56c252be9fa5360e576815357ee2bc28a30088e3"
    sha256                               x86_64_linux:  "0ac4540547034e22a4bc40e07fad9d45141b14c3ef8ca24429f4b99fb5df9769"
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
