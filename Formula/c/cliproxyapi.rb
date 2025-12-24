class Cliproxyapi < Formula
  desc "Wrap Gemini CLI, Codex, Claude Code, Qwen Code as an API service"
  homepage "https://github.com/router-for-me/CLIProxyAPI"
  url "https://github.com/router-for-me/CLIProxyAPI/archive/refs/tags/v6.6.50.tar.gz"
  sha256 "af288d6be24bfc36db67dff3b3458c9076bcfd5729f702ca01ec28af0187d921"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "dace3ef062e211848b893c0dc57a0808926b132021aea2896c6b07bed8e10219"
    sha256                               arm64_sequoia: "dace3ef062e211848b893c0dc57a0808926b132021aea2896c6b07bed8e10219"
    sha256                               arm64_sonoma:  "dace3ef062e211848b893c0dc57a0808926b132021aea2896c6b07bed8e10219"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d132c1b06a526ef4d00c79ebf1de127fd6a22800dd099ca40622de535ba4167"
    sha256                               arm64_linux:   "22de981e5a6cf06713ea74172f899fe6ddda58258842d965790a4ca3ccf6777f"
    sha256                               x86_64_linux:  "18acb1912bb93e8973f580626aaddfc21193339f27fab1c507b6385ef6efe46e"
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
