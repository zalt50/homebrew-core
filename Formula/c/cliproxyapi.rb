class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.54.tar.gz"
  sha256 "7a2cc304ec261a4e9054789d6468c1a054e887f6076e98c2ad48863990e70ad4"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e846a92848de029b589a1988dccbe6ff2043617a34b334f6b6a3c5673d153b62"
    sha256                               arm64_sequoia: "e846a92848de029b589a1988dccbe6ff2043617a34b334f6b6a3c5673d153b62"
    sha256                               arm64_sonoma:  "e846a92848de029b589a1988dccbe6ff2043617a34b334f6b6a3c5673d153b62"
    sha256 cellar: :any_skip_relocation, sonoma:        "383ec5574b7ab255e361a46f378aa3167bfb2d99594fcc345d16d298b8186948"
    sha256                               arm64_linux:   "ba78f869c12c97c96fc4b100469754eb552350e68300accc24cc8a7af4656130"
    sha256                               x86_64_linux:  "a9756e8d953ec74fb4deec4d74ab8cc4b7c7585753606c8a4892638606134301"
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
