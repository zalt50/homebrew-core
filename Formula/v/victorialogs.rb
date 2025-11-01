class Victorialogs < Formula
  desc "Open source user-friendly database for logs from VictoriaMetrics"
  homepage "https://docs.victoriametrics.com/victorialogs/"
  url "https://github.com/VictoriaMetrics/VictoriaLogs/archive/refs/tags/v1.37.2.tar.gz"
  sha256 "3f70cf19f5404fed3460a5255bfd6268508bf1a0384f12b9f7e7de24026b4f10"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "626c7a084f37c7fe0509dc184474aa6890145136590b9b48d20294b77e5f96c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "597a2ed0b3ea9912faf51a564f77fcf0e14f00741e3c7447f4c992e27747f8f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f72aae03590fa9c029de5c42d0f1a9225357e70a156cf46eff237db216ff349"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae46163c1549cf739f5c6f3a66eeb837a9f726ac4b9c16d57a4fad7ff89223af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f2ddf0145cac6e185df5df42a4661cfb4c6c1107628870b7745ac9bc4e803fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9299cdefd915efebef025c7475f9fd0bcd321ec856cbeb950065b65fc8209a16"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"victoria-logs"), "./app/victoria-logs"
  end

  service do
    run [
      opt_bin/"victoria-logs",
      "-httpListenAddr=127.0.0.1:9428",
      "-storageDataPath=#{var}/victorialogs-data",
    ]
    keep_alive false
    log_path var/"log/victoria-logs.log"
    error_log_path var/"log/victoria-logs.err.log"
  end

  test do
    http_port = free_port

    pid = fork do
      exec bin/"victoria-logs",
        "-httpListenAddr=127.0.0.1:#{http_port}",
        "-storageDataPath=#{testpath}/victorialogs-data"
    end
    sleep 5
    assert_match "Single-node VictoriaLogs", shell_output("curl -s 127.0.0.1:#{http_port}")

    assert_match version.to_s, shell_output("#{bin}/victoria-logs --version")
  ensure
    Process.kill(9, pid)
    Process.wait(pid)
  end
end
