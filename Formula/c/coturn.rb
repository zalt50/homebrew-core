class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.13.1.tar.gz"
  sha256 "c8f8db0e2d2d04d20535b2c928f9792ed5aa8cfd0af34f323a61749b2c7baba6"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "a29f585302ff29b4c9498fc82d94290cf37f3024fae7248906aee1a4d11590af"
    sha256               arm64_sequoia: "3913d2cb38b1d368ef0033e42c59cc1086e48a92345a33b69963a6429ff86020"
    sha256               arm64_sonoma:  "232f1f8d30a4cad5f530810532b771d9f13f0eb9d7cbf785c013f77e9f9b8310"
    sha256 cellar: :any, sonoma:        "bdfe117f6e5d3667f9ff07bb0941da78915b1088380072a94241dd8c2b828f94"
    sha256               arm64_linux:   "93d01e2692f75f55a8d95842e9a50817bf486eb5c387ecb9bcd01e8013dbd6f4"
    sha256               x86_64_linux:  "7a01879089731ec2268d9a88cbe24229ff6881c2e5a2e46fa1c62a329f108ee7"
  end

  depends_on "pkgconf" => :build
  depends_on "hiredis"
  depends_on "libevent"
  depends_on "libpq"
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  def install
    ENV["SSL_CFLAGS"] = "-I#{Formula["openssl@3"].opt_include}"
    ENV["SSL_LIBS"] = "-L#{Formula["openssl@3"].opt_lib} -lssl -lcrypto"
    system "./configure", "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--localstatedir=#{var}",
                          "--includedir=#{include}",
                          "--docdir=#{doc}",
                          *std_configure_args

    system "make", "install"

    man.mkpath
    man1.install Dir["man/man1/*"]
  end

  service do
    run [opt_bin/"turnserver", "-c", etc/"turnserver.conf"]
    keep_alive true
    error_log_path var/"log/coturn.log"
    log_path var/"log/coturn.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    system bin/"turnadmin", "-l"
  end
end
