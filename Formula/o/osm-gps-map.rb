class OsmGpsMap < Formula
  desc "GTK+ library to embed OpenStreetMap maps"
  homepage "https://github.com/nzjrs/osm-gps-map"
  url "https://github.com/nzjrs/osm-gps-map/releases/download/1.2.1/osm-gps-map-1.2.1.tar.gz"
  sha256 "277d6835220a6a2954e09eb304a8cd6ff49b72542c97c4fc36e53e905f2a747c"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 2
    sha256                               arm64_tahoe:   "e749fe56b5482a3a9418de1bba012a642a932b92fb092d669056f932a4a0f615"
    sha256                               arm64_sequoia: "1f92caba8e52495b92a2ed81e6e7f6959d25bb7ac12353872df3638d6ecbe7f1"
    sha256                               arm64_sonoma:  "12026a32374a2a8797d650c925fdc5ad9c19833c1019003d542e507e0fe80448"
    sha256                               arm64_ventura: "e7a42cd9f4293f91416301dfd756ce762dda325b466c511c4e9cfbeacc996e97"
    sha256                               sonoma:        "fd61181265716039211a690890598b64359740fc017868051062c23044641343"
    sha256                               ventura:       "6ab0a704cd25d754617aa95f97fcc8ea447def786f33771a3352c31a1fbc657f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40a000a5d4c6bc3b19b78e93ca25463f187a59a3f5ecd9187650955164ef7f09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1025b0a42d58429dfad4828bef5b3041e12a1bf54a8a849b3fc302f998a1c5d"
  end

  head do
    url "https://github.com/nzjrs/osm-gps-map.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libsoup"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  on_linux do
    depends_on "xorg-server" => :test
  end

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", "--enable-introspection", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <osm-gps-map.h>

      int main(int argc, char *argv[]) {
        OsmGpsMap *map;
        gtk_init (&argc, &argv);
        map = g_object_new (OSM_TYPE_GPS_MAP, NULL);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs osmgpsmap-1.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    if OS.linux? && ENV.exclude?("DISPLAY")
      system Formula["xorg-server"].bin/"xvfb-run", "./test"
    else
      system "./test"
    end
  end
end
