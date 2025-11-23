class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.11.tar.gz"
  sha256 "124bf83564af6b9e644d55216d44ff1f35f32e0e2f0f8f753276b6f4d66a1322"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "cb8255c8ced05a11a8cc943288aae9784f8f7d4a79c455411ed86b77fe1902b4"
    sha256                               arm64_sequoia: "cb8255c8ced05a11a8cc943288aae9784f8f7d4a79c455411ed86b77fe1902b4"
    sha256                               arm64_sonoma:  "cb8255c8ced05a11a8cc943288aae9784f8f7d4a79c455411ed86b77fe1902b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0f8a0101db2f3f100d576bd015d8654cfd76a94c5736d1510380e5e6c201642"
    sha256                               arm64_linux:   "11398d6f5920af2c3743f91a91cb2ff55ca6bd1cd09061514d5f5d5e177c5a33"
    sha256                               x86_64_linux:  "ac2ff5ce7564adf9d86ae234bc6e7740ef074d23f5c24378c23ef84613326553"
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
