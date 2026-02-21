class Termusic < Formula
  desc "Music Player TUI written in Rust"
  homepage "https://github.com/tramhao/termusic"
  url "https://github.com/tramhao/termusic/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "686f66856d755f2d2056a9548f074b11ba9568ac8075fafd8903e332bf166227"
  license all_of: ["MIT", "GPL-3.0-or-later"]

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build
  depends_on "sound-touch" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "tui", features: "cover-viuer-iterm")
    system "cargo", "install", *std_cargo_args(path: "server")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termusic --version")
    assert_match version.to_s, shell_output("#{bin}/termusic-server --version")

    output_log = testpath/"output.log"
    pid = if OS.mac?
      spawn bin/"termusic", [:out, :err] => output_log.to_s
    else
      require "pty"
      PTY.spawn(bin/"termusic", [:out, :err] => output_log.to_s).last
    end
    sleep 1
    assert_match "Server process ID", output_log.read
  ensure
    # Use KILL to ensure the process terminates, as TERM request to confirm exiting program.
    Process.kill("KILL", pid)
    Process.wait(pid)
  end
end
