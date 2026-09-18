class Libxo < Formula
  desc "Allows an application to generate text, XML, JSON, and HTML output"
  homepage "https://juniper.github.io/libxo/libxo-manual.html"
  url "https://github.com/Juniper/libxo/releases/download/2.2.0/libxo-2.2.0.tar.gz"
  sha256 "b72832d7c7108703f49750f92ccddbf904872adecc7be4cb67df7214b8d3d479"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_golden_gate: "04fbcf159682ab31753127e51891efdfc774b479b67845ab6d1e7d092def1079"
    sha256 arm64_tahoe:       "d2d3c107a346674ff206ba48ae1f116466ed308bff306cd07c7a72ee3d6c57f1"
    sha256 arm64_sequoia:     "e10688307bda5c4b611458951fb5927f1e65917703c5a29284df57a3ed683179"
    sha256 arm64_linux:       "fc0f74429a07e841874fbe93339eec7a70d8f51284fa18d3a0cde5d20960740b"
    sha256 x86_64_linux:      "7a4c0302db9e9f7c995355f7a4c849adda5028db8d6f300dd56c8fdca514e9b3"
  end

  depends_on "byacc" => :build # the XPath parser needs byacc, not bison
  depends_on "libtool" => :build
  depends_on "gettext"

  # Only include `bsd/string.h` in the gettext test when configure found it
  patch do
    url "https://github.com/Juniper/libxo/commit/dc0017cb7cea89363a27721f6ab4593305167b61.patch?full_index=1"
    sha256 "37f0bf7e9e01a94f185dbd59af3785688eaf4267bf4b8a76d92b1cbe6cfc5413"
    type :unofficial
    resolves "https://github.com/Juniper/libxo/pull/119"
  end

  deny_network_access!

  def install
    # Nothing uses libcrypto, but finding it adds -lcrypto to every link
    ENV["ac_cv_lib_crypto_MD5_Init"] = "no"

    # configure only looks for gettext in /usr, /opt/local and /usr/local
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-gettext=#{formula_opt_prefix("gettext")}",
                          "--prefix=#{prefix}"

    # glibc 2.38+ has `strlcpy` but does not declare it, so libxo leaves it
    # undefined in `libxo.so`; resolve it at load time (keeping the `-ldl` the
    # Makefile sets). Not needed on macOS, where `strlcpy` is in libc.
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
