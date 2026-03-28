class Btdu < Formula
  desc "Sampling disk usage profiler for btrfs"
  homepage "https://github.com/CyberShadow/btdu"
  url "https://github.com/CyberShadow/btdu/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "695ded59fb2029c8ae48ca0f990e68928841cdf36a4cf4cbc2485460cadbbd67"
  license "GPL-2.0-only"

  depends_on "btrfs-progs" => :build
  depends_on "dub" => :build
  depends_on "ldc" => :build
  uses_from_macos "ncurses"

  def install
    system "dub", "build", "-b", "release", "--compiler=ldc2"
    bin.install "btdu"
  end

  test do
    # This program requires sudo.
    assert_match "Fatal error: No path specified", shell_output("#{bin}/btdu 2>&1", 1)
  end
end
