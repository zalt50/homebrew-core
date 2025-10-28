class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.2.36.tar.gz"
  sha256 "84cc466e990f3e36f4e48f3526c129473831e08fa3f439dea0416741814be48f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "0a2e3c8f2f2bad66f69d737900e631962c8f86e3f37d5be2f334225e6d6373cc"
    sha256                               arm64_sequoia: "0a2e3c8f2f2bad66f69d737900e631962c8f86e3f37d5be2f334225e6d6373cc"
    sha256                               arm64_sonoma:  "0a2e3c8f2f2bad66f69d737900e631962c8f86e3f37d5be2f334225e6d6373cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "98d0f2354dac36c555ec079e1179fc8866ac8fef31dd9add5d86f1279095734f"
    sha256                               arm64_linux:   "1ef4c8ccf613e1edcc5e54e1c8a875dc2efbc68cbfe5fc997b8e2c56fbd7e029"
    sha256                               x86_64_linux:  "f8dcefd3334590d85dc033ef4a4a978ff83102926b9dd115923eded19d9bdc79"
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
