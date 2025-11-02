class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  # A mirror is used as primary URL because the official one is unstable.
  url "https://deb.debian.org/debian/pool/main/h/homebank/homebank_5.9.5.orig.tar.gz"
  mirror "http://homebank.free.fr/public/sources/homebank-5.9.5.tar.gz"
  sha256 "ff6c8b0f6da411133e29b848e91f48fdb88de40ad02cba20a8840930a3e7ed43"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/h/homebank/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "820cda0068a4720d01f39fceb8a33cd73d4d04886ed821d64a02e1e7cd6ff8fe"
    sha256 arm64_sequoia: "f480117e66c0726771d2057717be191d6363aaac1662a44c96a1321adfc42245"
    sha256 arm64_sonoma:  "3296c6aef169caad4a9571221e179d863202601b510cad117b4f2a8bf9ec2b49"
    sha256 arm64_ventura: "dfd4abf5802080526267066a1458a639a2c886f09912b1277eed8426ab750775"
    sha256 sonoma:        "fcc9c8a9b25feefde5ab29aaf3b85aa0191e4d960e8aa14ac9b0097a7217a85c"
    sha256 ventura:       "a987bc5a60eb4727d7c577b5f430a3d672e9cb73e807203c9938ebc669d2a5ec"
    sha256 arm64_linux:   "8dde2f054578494611d0e62925dd526d91af1b7612655825ee176f9564bf9b2f"
    sha256 x86_64_linux:  "4c261858c579c29f436888ebf5cc22c2d19f82a579a3ab982a61546ceec0c311"
  end

  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libofx"
  depends_on "libsoup"
  depends_on "pango"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    system "./configure", "--with-ofx", *std_configure_args
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    # homebank is a GUI application
    system bin/"homebank", "--help"
  end
end
