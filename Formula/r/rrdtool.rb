class Rrdtool < Formula
  desc "Round Robin Database"
  homepage "https://oss.oetiker.ch/rrdtool/"
  url "https://github.com/oetiker/rrdtool-1.x/releases/download/v1.10.2/rrdtool-1.10.2.tar.gz"
  sha256 "9787114551ee9b5db7c72722736388dcc54bf00ded51b5dd47feed11fb179fe4"
  license "GPL-2.0-or-later" => { with: "RRDtool-FLOSS-exception-2.0" }

  bottle do
    sha256 arm64_tahoe:   "d7a7aad73d786c6c4d8746c21deaa39a137c083770a91869055c0f594c8886db"
    sha256 arm64_sequoia: "c6b588754e3b2091ad91885d4f5bd31cdc34f34afb787de6871cabe53bea6c35"
    sha256 arm64_sonoma:  "4751683b4d6cb7e317c3e4a6f2cddb2e10f7b5ac8fd5ee357ea754ce784455d1"
    sha256 sonoma:        "be7355ecfea0e705a50e62ae66130e07b8c3e6a7d8c1d9d26407d61df026ff34"
    sha256 arm64_linux:   "71e84de2869dc540b374600ffa03608323c5d5836b84b6bbcff75068a14e9724"
    sha256 x86_64_linux:  "f47f3a9c7fb649bcdd9edaeae334dc48839add08e362ee0e566d70eb0c8fde42"
  end

  head do
    url "https://github.com/oetiker/rrdtool-1.x.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "libpng"
  depends_on "pango"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  def install
    args = %w[
      --disable-silent-rules
      --disable-lua
      --disable-perl
      --disable-python
      --disable-ruby
      --disable-tcl
    ]

    system "./bootstrap" if build.head?
    inreplace "configure", /^sleep 1$/, "#sleep 1"
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"rrdtool", "create", "temperature.rrd", "--step", "300",
      "DS:temp:GAUGE:600:-273:5000", "RRA:AVERAGE:0.5:1:1200",
      "RRA:MIN:0.5:12:2400", "RRA:MAX:0.5:12:2400", "RRA:AVERAGE:0.5:12:2400"

    system bin/"rrdtool", "dump", "temperature.rrd"
  end
end
