class Sysstat < Formula
  desc "Performance monitoring tools for Linux"
  homepage "https://sysstat.github.io/"
  url "https://github.com/sysstat/sysstat/archive/refs/tags/v12.7.9.tar.gz"
  sha256 "e48fc69401135dc08d2cd4ff58dbdbfce9b7485f76fc9049d97848e313c08dda"
  license "GPL-2.0-or-later"
  head "https://github.com/sysstat/sysstat.git", branch: "master"

  bottle do
    sha256 arm64_linux:  "6f45fccdd8224cb2f832366a9a83cba933d89d61a086594f120485438361a88d"
    sha256 x86_64_linux: "5a882f72e346c88bea61b53c2aeedf689e3fa0284f1b2bdea079bdec8cf653f7"
  end

  depends_on :linux

  def install
    system "./configure",
           "--disable-file-attr", # Fix install: cannot change ownership
           "--prefix=#{prefix}",
           "conf_dir=#{etc}/sysconfig",
           "sa_dir=#{var}/log/sa"
    system "make", "install"
  end

  test do
    assert_match("PID", shell_output("#{bin}/pidstat"))
    assert_match("avg-cpu", shell_output("#{bin}/iostat"))
  end
end
