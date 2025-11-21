class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.3.tar.gz"
  sha256 "63264cd0e190a6bcb80728f667972b70f59d3c381c64d4218176cddd5d793e7a"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "f1facae1a42be11db0b158b3069b335f4530f4fb5f3a40870c94cc1d0b4edfc2"
    sha256                               arm64_sequoia: "f1facae1a42be11db0b158b3069b335f4530f4fb5f3a40870c94cc1d0b4edfc2"
    sha256                               arm64_sonoma:  "f1facae1a42be11db0b158b3069b335f4530f4fb5f3a40870c94cc1d0b4edfc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5690fc52bc8f76e893d0ccc0ff639138666d74e0756b68a226a125bfaafdaed7"
    sha256                               arm64_linux:   "e7be29e0b73b6ba4b651f4f1e80f8fb8631dc6e44ac4e0995f389ce155dc939c"
    sha256                               x86_64_linux:  "349acbd4b751d7e64dfeeb5c1973fe65d16c48fb074932bd5b108727da8397d8"
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
