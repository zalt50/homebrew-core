class Libjaylink < Formula
  desc "Provide interoperability with JLINK hardware"
  homepage "https://gitlab.zapb.de/libjaylink/libjaylink"
  url "https://gitlab.zapb.de/libjaylink/libjaylink/-/archive/0.4.0/libjaylink-0.4.0.tar.bz2"
  sha256 "492da550fe1093a9b2d958304deb386380abea13ef7ce694b2ef68bfdaec664d"
  license "GPL-2.0-or-later"
  head "https://gitlab.zapb.de/libjaylink/libjaylink.git", branch: "master"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "libusb"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~CSRC
      #include <stdio.h>
      #include "libjaylink/libjaylink.h"

      int main(void)
      {
        printf("%d.%d.%d",
               jaylink_version_package_get_major(),
               jaylink_version_package_get_minor(),
               jaylink_version_package_get_micro());
        return 0;
      }
    CSRC
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ljaylink", "-o", "test"
    system "./test"
  end
end
