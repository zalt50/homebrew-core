class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.58.tar.gz"
  sha256 "23969c97700112aaa6877eb74cba63918c1c28b4acc161bedbb1bfb61309fb70"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "c87041f1b2ece399e55bcae10ee738f3e91f8a0c4300f270e91d3c1e94d6292e"
    sha256                               arm64_sequoia: "c87041f1b2ece399e55bcae10ee738f3e91f8a0c4300f270e91d3c1e94d6292e"
    sha256                               arm64_sonoma:  "c87041f1b2ece399e55bcae10ee738f3e91f8a0c4300f270e91d3c1e94d6292e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d2063aa4e0ee5360acdb7f1898de11b7b13fc8b7168fb1ed7c847921741d146"
    sha256                               arm64_linux:   "44dc92991e5e5d759e115560d670e99736fcb02fef5a4c06b281543baadd1d9e"
    sha256                               x86_64_linux:  "c97680430873fbc18d57e22a16dfa531c8e5879ba8c0f83ec511669b0421397c"
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
