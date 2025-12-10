class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.5.65.tar.gz"
  sha256 "bb5535eb2171ffc0dda5a605e766ed1d02dfeee66ea25e540247b171069485b4"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "eedc4a497559313b8e5fc96768e66bf2a54ab5fba8fcaf78db2a2e3ef2ccaaa6"
    sha256                               arm64_sequoia: "eedc4a497559313b8e5fc96768e66bf2a54ab5fba8fcaf78db2a2e3ef2ccaaa6"
    sha256                               arm64_sonoma:  "eedc4a497559313b8e5fc96768e66bf2a54ab5fba8fcaf78db2a2e3ef2ccaaa6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3872f2b801e8b5279dd7000759749c6844887e549bed4abf05dd38f969e30a1"
    sha256                               arm64_linux:   "36a76cf6042f27e488603888114712ae81a5276eed47f88760eda9e9f3876cf7"
    sha256                               x86_64_linux:  "435fe0cb52c9c2f94d10fc6cf77611d863ea006d17e40b0c1e9fe8af8e8450a7"
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
