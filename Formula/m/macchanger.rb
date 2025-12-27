class Macchanger < Formula
  desc "Change your mac address, for macOS"
  homepage "https://github.com/shilch/macchanger"
  url "https://github.com/shilch/macchanger/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "87192a3549baa771736ec3f9c2017f533d304efc7b7d968aadc1226e08f1673b"
  license "GPL-2.0-only"

  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macchanger --version")
    assert_match "Please specify an interface name", shell_output("#{bin}/macchanger --show 2>&1", 1)
  end
end
