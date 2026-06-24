class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/0.22.0/libpsl-0.22.0.tar.gz"
  mirror "http://distfiles.macports.org/libpsl/libpsl-0.22.0.tar.gz"
  sha256 "c45c3aa17576b99873e05a9b09a44041b065bbfa390e6d474d06fbfaeb9c7722"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3c4819817efda046038fe4dcf4d82c218c5ef48a9a147f2ed6e24a30703d8c1c"
    sha256 cellar: :any, arm64_sequoia: "247ca6f370f62e262875a552da94d16623ec8d099ef18a4c32a7de738b17a875"
    sha256 cellar: :any, arm64_sonoma:  "c4bd88dfa97f5f1bc9c42a9f14e11cd5ed5255c353474902d4dd877b8d5c522b"
    sha256 cellar: :any, sonoma:        "84565757d4d0c734752c7fd48b22717b116918637fa5a0a491995edb6dff2bd6"
    sha256 cellar: :any, arm64_linux:   "8a6259680220230609b6a8893662778becb3a4823f4002de273a518f8dcc2145"
    sha256 cellar: :any, x86_64_linux:  "7e2a10eff5f58dd812693f98ad804b4ff3992966e9d64d01d0637fc95a43e9e0"
  end

  depends_on "pkgconf" => :build
  depends_on "libidn2"
  depends_on "libunistring"

  uses_from_macos "python" => :build

  def install
    # Reduce overlinking similar to Meson build
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

    args = %w[
      --disable-silent-rules
      --enable-builtin
      --enable-runtime=libidn2
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <stdio.h>
      #include <string.h>

      #include <libpsl.h>

      int main(void)
      {
          const psl_ctx_t *psl = psl_builtin();

          const char *domain = ".eu";
          assert(psl_is_public_suffix(psl, domain));

          const char *host = "www.example.com";
          const char *expected_domain = "example.com";
          const char *actual_domain = psl_registrable_domain(psl, host);
          assert(strcmp(actual_domain, expected_domain) == 0);

          return 0;
      }
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{include}", "-L#{lib}", "-lpsl"
    system "./test"
  end
end
