class Bbrew < Formula
  desc "TUI for managing Homebrew, Flatpak, and Mac App Store packages"
  homepage "https://bold-brew.com"
  url "https://github.com/Valkyrie00/bold-brew/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "ddf3d5e69da599fe6cb9660c50895b3572f31abb511d25e5d39547e9e7e95ae0"
  license "MIT"
  head "https://github.com/Valkyrie00/bold-brew.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X bbrew/internal/services.AppVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bbrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bbrew -v")

    output = shell_output("#{bin}/bbrew -f #{testpath}/nonexistent.Brewfile 2>&1", 1)
    assert_match "brewfile not found", output

    ENV["TERM"] = "xterm"
    require "pty"
    PTY.spawn(bin/"bbrew") do |r, _w, pid|
      r.winsize = [80, 43]
      sleep 7
      Process.kill "TERM", pid
      assert_match "Bold Brew", r.read_nonblock(512)
    end
  end
end
