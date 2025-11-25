class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.18.tar.gz"
  sha256 "27cd03f8d5124d9dae5d8640c96942a39dd57b847354213ab42ed617d4e1b520"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "5fb92d9bd8462dac2a5998820a1cdabb3d1e783446b6e80a6a11b2b8ae054d1b"
    sha256                               arm64_sequoia: "5fb92d9bd8462dac2a5998820a1cdabb3d1e783446b6e80a6a11b2b8ae054d1b"
    sha256                               arm64_sonoma:  "5fb92d9bd8462dac2a5998820a1cdabb3d1e783446b6e80a6a11b2b8ae054d1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6d99e9b0db72f49202c0d4595bdf5d8a7a5ef59a11f688dae29335607a83c62"
    sha256                               arm64_linux:   "d7c012607925ab12ec132c14978d08cc0c1d70f5298832adf045dd0c669cd48c"
    sha256                               x86_64_linux:  "5483fbd7791e0fbc9f07eba71d5938f65a23a3c5b0257a2a801d7c571e465621"
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
