class Libdecor < Formula
  desc "Client-side decorations library for Wayland client"
  homepage "https://gitlab.freedesktop.org/libdecor/libdecor"
  url "https://gitlab.freedesktop.org/libdecor/libdecor/-/releases/0.2.4/downloads/libdecor-0.2.4.tar.xz"
  sha256 "b17cf420e8dcb526bf82da5d36f8443a91fad0777083fa4ec5c1df8ee877416f"
  license "MIT"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "dbus"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on :linux
  depends_on "pango"
  depends_on "wayland"
  depends_on "wayland-protocols"

  def install
    system "meson", "setup", "build", "-Ddemo=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libdecor.h>

      int main() {
        struct libdecor *context;
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}/libdecor-0"
    system "./test"
  end
end
