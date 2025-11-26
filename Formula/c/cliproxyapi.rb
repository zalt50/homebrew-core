class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.21.tar.gz"
  sha256 "c762beed9ccaad38e4ac1e9829cec7476a9764a5633360e9e03b341db571df98"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "ad8afb6baf022845b0aff3603b1bcb740bbaf13476dc50e8fb05cdf1a46dfdf8"
    sha256                               arm64_sequoia: "ad8afb6baf022845b0aff3603b1bcb740bbaf13476dc50e8fb05cdf1a46dfdf8"
    sha256                               arm64_sonoma:  "ad8afb6baf022845b0aff3603b1bcb740bbaf13476dc50e8fb05cdf1a46dfdf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc625757578e13dafd398bb49f6e51e97b1bd73d5048fd3bea955cd6d78e2d82"
    sha256                               arm64_linux:   "01a6c607d9ef04ab99b7eb2febb74d543ea938b3fb3a91b7b9f2ff3d3bfdccb3"
    sha256                               x86_64_linux:  "cb6d8f0b59142871ced227f7184a337db7e11fd6795b5ae24abacd8af29e7153"
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
