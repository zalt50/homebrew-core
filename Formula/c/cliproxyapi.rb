class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.57.tar.gz"
  sha256 "afe426e8261342e19a27edd7d1ad0940312d8b7b523966940c3838cdc571620a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0939dbd7941fdceec9ba8de0434c9d2c1c5799dcfc5a70d12e2aa5de76cad2ed"
    sha256                               arm64_sequoia: "0939dbd7941fdceec9ba8de0434c9d2c1c5799dcfc5a70d12e2aa5de76cad2ed"
    sha256                               arm64_sonoma:  "0939dbd7941fdceec9ba8de0434c9d2c1c5799dcfc5a70d12e2aa5de76cad2ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "565597dfc6c461b4af1dab7ff53bef1f3f24400d0dd97b588123f4f82145bc1b"
    sha256                               arm64_linux:   "2f2167a73f5d9e48b0fd23d3bb9ef02e4a6efcffc015d97208750f34e80cb062"
    sha256                               x86_64_linux:  "453077526d7e3536c735aa0dc387f9220894d9eb2c01be128c74f4752d0cb365"
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
