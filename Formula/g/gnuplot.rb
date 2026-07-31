class Gnuplot < Formula
  desc "Command-driven, interactive function plotting"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/6.0.5/gnuplot-6.0.5.tar.gz"
  sha256 "73237f37f03306d68bfae133a9a50d5e9341384e198d5ab37eeca9ab534deed8"
  license "gnuplot"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{url=.*?/gnuplot[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "2423f8956648248d70bca9f18a3d01ae80093ba2fb6285456220af59d48f1e88"
    sha256 arm64_sequoia: "ca167276564b8dde7ffb580be087aa783fcb51d64f6981e434bb08faaf806736"
    sha256 arm64_sonoma:  "58a259f287608c11bd4533bc8bb2c4809a9141a915608ad520374fed391dd800"
    sha256 sonoma:        "a85e158ae09b9ea340fb6203d2932c5c59479d2e68530e505d0236590a5e4e77"
    sha256 arm64_linux:   "28cd7475405d3677b56f326d9a9b35fab9deb3d62110628030ab9e7015c4bfb2"
    sha256 x86_64_linux:  "dbd1c5da00d909c309acd5354b6063ae903fa1a91961c739b1625af87538de80"
  end

  head do
    url "https://git.code.sf.net/p/gnuplot/gnuplot-main.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "qttools" => :build

  depends_on "cairo"
  depends_on "gd"
  depends_on "glib"
  depends_on "libcerf"
  depends_on "lua"
  depends_on "pango"
  depends_on "qt5compat"
  depends_on "qtbase"
  depends_on "qtsvg"
  depends_on "readline"
  depends_on "webp"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    args = %W[
      --disable-silent-rules
      --with-readline=#{formula_opt_prefix("readline")}
      --disable-wxwidgets
      --with-qt
      --without-x
      --without-latex
    ]

    ENV.append "CXXFLAGS", "-std=c++17" # needed for Qt 6
    system "./prepare" if build.head?
    system "./configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
    ENV.deparallelize # or else emacs tries to edit the same file with two threads
    system "make"
    system "make", "install"
  end

  test do
    system bin/"gnuplot", "-e", <<~EOS
      set terminal dumb;
      set output "#{testpath}/graph.txt";
      plot sin(x);
    EOS
    assert_path_exists testpath/"graph.txt"
  end
end
