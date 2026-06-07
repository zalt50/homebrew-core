class GdkPixbuf < Formula
  desc "Toolkit for image loading and pixel buffer manipulation"
  homepage "https://gtk.org"
  url "https://download.gnome.org/sources/gdk-pixbuf/2.44/gdk-pixbuf-2.44.6.tar.xz"
  sha256 "140c2d0b899fcf853ee92b26373c9dc228dbcde0820a4246693f4328a27466fa"
  license "LGPL-2.1-or-later"
  revision 1
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "023b480ec88e40ba0b7879663177a7baaa009d93853cf74b313ce1029f8e7c5b"
    sha256 arm64_sequoia: "eed711bc1bc0a308e57ddcdcb0c5ab3e40cd03d47ecf82f344b508e1f4317475"
    sha256 arm64_sonoma:  "f05616e33ac2730638a5e31d6f2835b05b17b08d94feabf773e8c3a92322016a"
    sha256 sonoma:        "af601b57fead60ddd3d08af5025d41876d37d6f1cf9348bd79e03611b6d56ff7"
    sha256 arm64_linux:   "2cf25e29b84262b52aa087c5ea8d8f113160e1ed107f50410203cd4d3244e7aa"
    sha256 x86_64_linux:  "de021570fbdc6b613d5d620620f8ca735371d7fd5f442fbb127eb2e0331a56df"
  end

  depends_on "docutils" => :build # for rst2man
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "shared-mime-info"
  end

  def install
    # Use HOMEBREW_PREFIX to find modules installed by dependents without
    # needing environment variables or inreplaces. In order to support this,
    # we need install into a staging directory.
    meson_args = std_meson_args.map { |s| s.sub prefix, HOMEBREW_PREFIX }
    ENV["DESTDIR"] = buildpath/"stage"

    system "meson", "setup", "build", "-Drelocatable=false",
                                      "-Dnative_windows_loaders=false",
                                      "-Dtests=false",
                                      "-Dinstalled_tests=false",
                                      "-Dman=true",
                                      "-Dgtk_doc=false",
                                      "-Dpng=enabled",
                                      "-Dtiff=enabled",
                                      "-Djpeg=enabled",
                                      "-Dothers=enabled",
                                      "-Dintrospection=enabled",
                                      "-Dglycin=disabled",
                                      *meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    prefix.install Pathname(File.join("stage", HOMEBREW_PREFIX)).children
  end

  post_install_steps do
    gdk_pixbuf_query_loaders
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gdk-pixbuf/gdk-pixbuf.h>

      int main(int argc, char *argv[]) {
        GType type = gdk_pixbuf_get_type();
        return 0;
      }
    C

    gdk_pixbuf_pc = lib.glob("pkgconfig/gdk-pixbuf-*.pc").first.basename(".pc")
    flags = shell_output("pkgconf --cflags --libs #{gdk_pixbuf_pc}").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    # Check that HOMEBREW_PREFIX paths are used
    gdk_pixbuf_cache_file = shell_output("pkgconf --variable=gdk_pixbuf_cache_file #{gdk_pixbuf_pc}").chomp
    loaders = shell_output(bin/"gdk-pixbuf-query-loaders")
    assert_match "#{HOMEBREW_PREFIX}/lib/", gdk_pixbuf_cache_file
    assert_match "LoaderDir = #{HOMEBREW_PREFIX}/lib/gdk-pixbuf-", loaders
    refute_match prefix.realpath.to_s, loaders
  end
end
