class Libxo < Formula
  desc "Allows an application to generate text, XML, JSON, and HTML output"
  homepage "https://juniper.github.io/libxo/libxo-manual.html"
  url "https://github.com/Juniper/libxo/releases/download/2.0.0/libxo-2.0.0.tar.gz"
  sha256 "982de1877309dd9d57f4cabf2c8bbf42c1c15dc402cd8586ab1e4eabaea298eb"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_tahoe:    "c68c67c6e39b78400523b00d29533997b73c324847c4a0682fc3409c9bd7ca58"
    sha256 arm64_sequoia:  "1dd19ecfae3f49f288fda04ded88e72b735284a1bb904e9df2e6c5ae64f26d50"
    sha256 arm64_sonoma:   "4c55e5145b840b968e7a3b02b7806034c7a7a463d0761ad405594518a3ba52ef"
    sha256 arm64_ventura:  "d032a1e05fa91f2d0ffc90c86361f9fcf3239ae11dc053583ef9d1d964d86c55"
    sha256 arm64_monterey: "7efad6f78bca7183e0ed73dbaa895d6e545e60b58e3b2e1cb9e18593a835c2c4"
    sha256 sonoma:         "9176bd1a62a3c7e3781cdfd1c2fd2f8958b468d08f6086a4229741e4f32e4229"
    sha256 ventura:        "0f9aa2f3a1257b686116e9a936662759fb7f5b61134fb810f1d30085951e6f54"
    sha256 monterey:       "c9beeccc9174bba7cdf02f3455e1984b2c4c37d67b8330e8a9a18101b7239f06"
    sha256 arm64_linux:    "17647ad9619b33d7dd984b9c04312e5d717a6bd078608be42b17882ed6ad4237"
    sha256 x86_64_linux:   "5fa4473b566e7039ec3b98394c7ce6c863cbe3f4eeacc000012976a4cde4ea83"
  end

  depends_on "libtool" => :build
  depends_on "gettext"

  on_linux do
    # The XPath parser is generated with byacc-only options (`-P`, `-s`); the
    # `yacc` on Linux is bison, which rejects them.
    # Upstream fix: https://github.com/Juniper/libxo/pull/116
    depends_on "byacc" => :build
  end

  def install
    # `bool` is used as an identifier, which C23 no longer allows
    ENV["ac_cv_prog_cc_c23"] = "no"
    # Nothing uses libcrypto, but finding it adds -lcrypto to every link
    ENV["ac_cv_lib_crypto_MD5_Init"] = "no"

    # libxo uses `bool` as an identifier; GCC 15+ defaults to C23 where it is a
    # keyword, and `ac_cv_prog_cc_c23=no` only stops configure adding `-std=c23`.
    # Upstream fix: https://github.com/Juniper/libxo/pull/116
    ENV.append_to_cflags "-std=gnu17" if OS.linux?

    # glibc provides gettext in libc and ships no `libintl`, so the `-lintl`
    # detection fails and the (ungated) msgfmt check aborts. Make it non-fatal;
    # libxo then builds without gettext, as it did before 2.0.0.
    # Upstream fix: https://github.com/Juniper/libxo/pull/116
    if OS.linux?
      inreplace "configure", 'as_fn_error $? "\"could not find msgfmt tool\"',
                             ': $? "\"could not find msgfmt tool\"'
    end

    # configure only looks for gettext in /usr, /opt/local and /usr/local
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-gettext=#{formula_opt_prefix("gettext")}",
                          "--prefix=#{prefix}"

    # The generated `xo_xpath.tab.h` has no ordered prerequisite on the objects
    # that include it, which races under parallel make.
    # Upstream fix: https://github.com/Juniper/libxo/pull/116
    ENV.deparallelize

    # glibc 2.38+ has `strlcpy` but does not declare it, so libxo leaves it
    # undefined in `libxo.so`; resolve it at load time (keeping the `-ldl` the
    # Makefile sets). Not needed on macOS, where `strlcpy` is in libc.
    # Upstream fix: https://github.com/Juniper/libxo/pull/116
    if OS.linux?
      system "make", "install", "LDFLAGS=-ldl -Wl,--allow-shlib-undefined"
    else
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libxo/xo.h>
      int main() {
        xo_set_flags(NULL, XOF_KEYS);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxo", "-o", "test"
    system "./test"
  end
end
