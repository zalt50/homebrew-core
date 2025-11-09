class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.24.tar.gz"
  sha256 "45f7befc865f8c1b49dbfbe10d12f0944506298f91397041320221be3dd9b3b8"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e9422151c39803b79f1b84cc5cd6ef39d2578f58fe002e6dc67329e5b53bfee1"
    sha256                               arm64_sequoia: "e9422151c39803b79f1b84cc5cd6ef39d2578f58fe002e6dc67329e5b53bfee1"
    sha256                               arm64_sonoma:  "e9422151c39803b79f1b84cc5cd6ef39d2578f58fe002e6dc67329e5b53bfee1"
    sha256 cellar: :any_skip_relocation, sonoma:        "916c29deba76139732f20326162c5acb9f19977eca7ec6571229c3947551aaf2"
    sha256                               arm64_linux:   "a211e67cd49a968ebc265209a1abd56824c34a9d986e39ad3c85e370d551e550"
    sha256                               x86_64_linux:  "50d21038fa9e334dbe80083ff7cab3907802d7c4be1ca35eb1c96a815f0d3786"
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
