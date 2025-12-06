class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.49.tar.gz"
  sha256 "1d9f50c07206d944724205c931ac7e958e444292239f28cfe83ba66593a7a0e8"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "5479c9a0654622926403e1cd9e55942272c4e141aa532bb9fed89b271055a596"
    sha256                               arm64_sequoia: "5479c9a0654622926403e1cd9e55942272c4e141aa532bb9fed89b271055a596"
    sha256                               arm64_sonoma:  "5479c9a0654622926403e1cd9e55942272c4e141aa532bb9fed89b271055a596"
    sha256 cellar: :any_skip_relocation, sonoma:        "df879ea48ba7e02d9596bcb85ff52866dee78713294fc4eb01226dbb0a148cde"
    sha256                               arm64_linux:   "4d7c2464c7fe387661af5a085279944dfd7982d8d6855a5c49da3fb1151f1dd2"
    sha256                               x86_64_linux:  "19c5c2861246bbf30fa6f8ae9a50492744026ad47ed1fa6d212ef1c29afafa38"
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
