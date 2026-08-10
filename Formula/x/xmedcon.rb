class Xmedcon < Formula
  desc "Medical image conversion toolkit"
  homepage "https://xmedcon.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmedcon/XMedCon-Source/0.26.2/xmedcon-0.26.2-gtk3.tar.gz"
  version "0.26.2"
  sha256 "fff4fca2860974b0d2b4ec1c5813c4fc80ca9fa8d44cef6f15ad50eda1e7e5cc"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]
  head "https://git.code.sf.net/p/xmedcon/code.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build
  depends_on "pkgconf" => :build
  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on "libpng"
  depends_on "pango"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-dependency-tracking", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "medcon.h"
      int main() {
        MdcInit();
        printf("%s", MdcGetLibLongVersion());
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}",
            "-lmdc", "-o", "test"
    assert_match "(X)MedCon #{version} by Erik Nolf", shell_output("./test")
  end
end
