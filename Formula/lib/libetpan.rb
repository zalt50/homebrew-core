class Libetpan < Formula
  desc "Portable mail library handling several protocols"
  homepage "https://www.etpan.org/libetpan.html"
  url "https://github.com/dinhvh/libetpan/archive/refs/tags/1.10.tar.gz"
  sha256 "0ca9a79f66155e12156727856a40031030f5760f7bc88b29119e851b9c96e9eb"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/dinhvh/libetpan.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "2f2bc6b0e25e04a695cbfb726a3cfcf699098d8bcb3f65341ce73bc7fe5ac2e6"
    sha256 cellar: :any,                 arm64_sequoia: "0f71f334cab29455274e4c1a1ea4db7d20eb8d3cd6f52a3380343c62f5473359"
    sha256 cellar: :any,                 arm64_sonoma:  "ba50402af4e428540093a35f7493abfa5061dba3a80063c8356af13278d6b0d9"
    sha256 cellar: :any,                 sonoma:        "6c780a96c2675aeb1dc3130c91a46f75e673e12ef3cc8a381d6973496a3ba361"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "793b454d15058dc0ba62741b7e094e27f9f311bcd56ec7fed2e197011b54eb6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf8c5f3550de87ef79a8037cba4778e4d148581c4ef4b28353a3eb80cad9aa61"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  uses_from_macos "cyrus-sasl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # autoconf 2.71+ probes -std=gnu23 first on modern compilers, which rejects K&R. Force gnu17.
    ENV.append "CFLAGS", "-std=gnu17"

    if OS.mac?
      # Keep macOS-native TLS (CFNetwork/Security) compiled in.
      ENV.append "CPPFLAGS", "-DHAVE_CFNETWORK=1"
      ENV.append "LDFLAGS", "-framework CoreFoundation -framework CoreServices -framework Security"
    end

    system "./autogen.sh", "--disable-db", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libetpan/libetpan.h>
      #include <string.h>
      #include <stdlib.h>

      int main(int argc, char ** argv)
      {
        printf("version is %d.%d",libetpan_get_version_major(), libetpan_get_version_minor());
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-letpan", "-o", "test"
    system "./test"
  end
end
