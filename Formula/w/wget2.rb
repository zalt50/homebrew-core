class Wget2 < Formula
  desc "Successor of GNU Wget, a file and recursive website downloader"
  homepage "https://gitlab.com/gnuwget/wget2"
  url "https://ftpmirror.gnu.org/wget/wget2-2.3.0.tar.gz"
  sha256 "4f1915b2a55a789a15f2f9ada7cc44bca81418e648f76fd88a7f4dd028b2149f"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/href=.*?wget2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "7a198593e72317dd69a0099c236bbf850c0cd42aa3c648493bf9dba29870cce2"
    sha256 arm64_tahoe:       "3b785836084f972fba43ca8b82ac44ca5447a3c236572d67713e26c2209ee256"
    sha256 arm64_sequoia:     "b394a3b18b61da6bab9eac8ccfe2640cc19e8b38ed99cf48d0505ef0cd290def"
    sha256 arm64_sonoma:      "bde42c49861a7e2447ae1aecba381f89691216546f4170d7c2e2a84d307db887"
    sha256 sonoma:            "0bfa0d93f335be723eadeb95e1c9a2c363d0f72091c35b54ed91addb4486fd1b"
    sha256 arm64_linux:       "0590c522205ec4d00168634fb328cd6abd04d67fad862b9ca1b5d76024f41cbb"
    sha256 x86_64_linux:      "b70d0eee960f3393dc3f6e91012bfec0e244d18aab3e21841c7c8d4a8e7f9f19"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "libtool" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build # Build fails with macOS-provided `texinfo`

  depends_on "brotli"
  depends_on "gnutls"
  depends_on "gpgme"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "libpsl"
  depends_on "lzlib" # static lib
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "gnu-sed" => :build
    depends_on "gettext"
  end

  on_linux do
    depends_on "gettext" => :build
    depends_on "zlib-ng-compat"
  end

  # Fix `GNULIB_LIBS` being assigned an empty value by the unquoted `AC_SUBST`
  # TODO: remove along with `autoreconf` and its build dependencies in the next release
  patch do
    url "https://gitlab.com/gnuwget/wget2/-/commit/e80d42ac035c1098f98ca447a418d19ac883160c.diff"
    sha256 "7b253e3e7173b78711d5df370069132792331fa2f043152255762c88ec74a2ba"
    type :backport
    resolves "https://gitlab.com/gnuwget/wget2/-/issues/724"
  end

  allow_network_access! :test

  def install
    # The pattern used in 'docs/wget2_md2man.sh.in' doesn't work with system sed
    ENV.prepend_path "PATH", formula_opt_libexec("gnu-sed")/"gnubin" if OS.mac?

    ENV.append "LZIP_CFLAGS", "-I#{formula_opt_include("lzlib")}"
    ENV.append "LZIP_LIBS", "-L#{formula_opt_lib("lzlib")} -llz"

    args = %w[
      --disable-silent-rules
      --with-bzip2
      --with-lzma
    ]
    args << "--with-libintl-prefix=#{formula_opt_prefix("gettext")}" if OS.mac?

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *args, *std_configure_args
    system "make", "install"

    # Remove `wget2_noinstall` binary, which is only for testing
    # https://gitlab.com/gnuwget/wget2/-/work_items/565#note_699151912
    rm bin/"wget2_noinstall"
  end

  test do
    system bin/"wget2", "-O", File::NULL, "https://google.com"
  end
end
