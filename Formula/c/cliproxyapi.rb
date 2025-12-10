class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.0.tar.gz"
  sha256 "d615bd79c2930f4140c29f177aa26d953e9ee4e80ca8cae7994c12f7cc548698"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "a7358fe7892316a7cb238fa3ea7cf6ddc2148335564658ed1ac512883f49e5c6"
    sha256                               arm64_sequoia: "a7358fe7892316a7cb238fa3ea7cf6ddc2148335564658ed1ac512883f49e5c6"
    sha256                               arm64_sonoma:  "a7358fe7892316a7cb238fa3ea7cf6ddc2148335564658ed1ac512883f49e5c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4d33b85cac89a475b484cd83dad59cd1485e7ca16c55e9e03ca546c6c20884e"
    sha256                               arm64_linux:   "803fd58590fb732f9119473d08b78c2573687232933dedd029a6d711ed1b46aa"
    sha256                               x86_64_linux:  "d4804f6825e20150d16e3bbbfc519739d0b827931ae0610e8238dc100ff812ee"
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
