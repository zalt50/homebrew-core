class Rrdtool < Formula
  desc "Round Robin Database"
  homepage "https://oss.oetiker.ch/rrdtool/"
  url "https://github.com/oetiker/rrdtool-1.x/releases/download/v1.10.1/rrdtool-1.10.1.tar.gz"
  sha256 "79a0a4caaa278d42b4208048b2c5b28fced0dd8d4498bbcabac42e5641cc1b20"
  license "GPL-2.0-or-later" => { with: "RRDtool-FLOSS-exception-2.0" }

  bottle do
    sha256 arm64_tahoe:   "548240981a8897745af18a9b268cc020a90ec6309ddddee5b249c8e0860b53b1"
    sha256 arm64_sequoia: "e769db8ff06d1f86c753efaadf8cec484a5b90bdc9fcc157ab0fbe8612610498"
    sha256 arm64_sonoma:  "d38904105fed8672844f70effb1ee5724b845f6e110fe55cbdea23c916f6a59d"
    sha256 sonoma:        "d98d2aaf8ec0f813c0fde4a06252b3bd206579f8f26e0e8aebcb88d34f13c95b"
    sha256 arm64_linux:   "3bc32e3b8774e43da766e9d06cbbd2832e475aa128c26842a8b6f7e0d2fc52ae"
    sha256 x86_64_linux:  "8125cdf721e3ab5572b6b9dde5c7a829dd9135366da513794c69ddaa78c22966"
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
