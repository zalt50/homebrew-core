class Rlwrap < Formula
  desc "Readline wrapper: adds readline support to tools that lack it"
  homepage "https://github.com/hanslub42/rlwrap"
  url "https://github.com/hanslub42/rlwrap/archive/refs/tags/v0.48.tar.gz"
  sha256 "b2721b1c0147aaafc98e6a31d875316ba032ad336bec7f2a8bc538f9e3c6db60"
  license "GPL-2.0-or-later"
  head "https://github.com/hanslub42/rlwrap.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "eb09e4aefabca75272dab10c2c5bec2328143eaf0f64079a521a07f96e6e9d9d"
    sha256 arm64_sequoia: "4531f405efca8347511d5202d49ceb050a84a746b79d5ca8eb7ea1812b7c247e"
    sha256 arm64_sonoma:  "76f2e2a11cf4e3e808cceaa10de99b81080d8b01f73e3a138cefbe34d3bcfee3"
    sha256 sonoma:        "07017b0f2997ee3366f699446870544d6cbb0e5480761ab0c5952f88ffd16c80"
    sha256 arm64_linux:   "bbad3c2af39b1a2bef447a61dd934f3d1924f9bc361cebbac97ef866695b38b7"
    sha256 x86_64_linux:  "eb12a645ba61447c3ab939a989805565007fcfbb2975e04818b3a59c373dbe0d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libptytty"
  depends_on "readline"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"rlwrap", "--version"
  end
end
