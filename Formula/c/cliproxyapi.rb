class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.3.51.tar.gz"
  sha256 "d8c96b9cbf49a2941a1a36a520dca45039cb1f436f727bde1e0dbb192d7cd089"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0b77cf2d5846c16651fab7dec1770146c2d028c30083909182bd451eaf72f0e2"
    sha256                               arm64_sequoia: "0b77cf2d5846c16651fab7dec1770146c2d028c30083909182bd451eaf72f0e2"
    sha256                               arm64_sonoma:  "0b77cf2d5846c16651fab7dec1770146c2d028c30083909182bd451eaf72f0e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa4a59e6e17983d11bd1d2a3abaead97f710e2d35037cddb698d57edf57af720"
    sha256                               arm64_linux:   "5c29578827755d11603d05382d72f7da91c7855e93adca58c921bba0e1269ade"
    sha256                               x86_64_linux:  "fafae1bc5b0c550c733012acc4281bbce52194b9bd21a70835c0d541f5408de0"
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
