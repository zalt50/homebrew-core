class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.30.tar.gz"
  sha256 "06fd033c44c16a08f36b97ba8bbdcd3e67071546fb17d76358a4c6ba2fa57a58"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e8600900d02e5b54f6bbb7181ad6b817c2319201904bb57f13050c2107872273"
    sha256                               arm64_sequoia: "e8600900d02e5b54f6bbb7181ad6b817c2319201904bb57f13050c2107872273"
    sha256                               arm64_sonoma:  "e8600900d02e5b54f6bbb7181ad6b817c2319201904bb57f13050c2107872273"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d760b62f5550d8eb7b52581b78b37e6026b1bcc12b12e212f5dc4a42c894718"
    sha256                               arm64_linux:   "11fe94e3b2144c9ed76761091d01de291968f752476cd73d7438d367aa6c95c2"
    sha256                               x86_64_linux:  "f86e0e01a943ce714a3119ad4d2f24ae3fac1dedcc3ade6e758d7b7e2b3edcf9"
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
