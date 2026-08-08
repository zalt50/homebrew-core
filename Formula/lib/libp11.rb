class Libp11 < Formula
  desc "PKCS#11 wrapper library in C"
  homepage "https://github.com/OpenSC/libp11/wiki"
  url "https://github.com/OpenSC/libp11/releases/download/libp11-0.4.20/libp11-0.4.20.tar.gz"
  sha256 "a125e0310ff10c189fc1b32a9652101486ea94a6b07c677a30e90e3638d2db48"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^libp11[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "97e58b3f8dbe3ec5427939e2e04dc4a2c8634fc5149e4d4f05b5f17e6430a7c2"
    sha256 cellar: :any, arm64_sequoia: "028157d1edea451f6a386c5266c18f1792203792c903d1ccfac452c6bd250950"
    sha256 cellar: :any, arm64_sonoma:  "6a8779d49170b3e092ef1a8156bda249f4aa5a74ed82cdeea9a25bb17564409f"
    sha256 cellar: :any, sonoma:        "dc621d302ee73159730d28fc7bc12f00de381aa095238748e579890c8fe84701"
    sha256 cellar: :any, arm64_linux:   "18f39b1aef751fd100d49a07600c2fc3ad0f22bae686206fb0bb4947dd967cea"
    sha256 cellar: :any, x86_64_linux:  "8fd4ff7067a37019406df915e9b55354f1ad8f1b11bc379ab7dcd9ba34a2c48c"
  end

  head do
    url "https://github.com/OpenSC/libp11.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libtool"
  depends_on "openssl@3"

  def install
    openssl = deps.find { |d| d.name.match?(/^openssl/) }
                  .to_formula
    enginesdir = Utils.safe_popen_read("pkgconf", "--variable=enginesdir", "libcrypto").chomp
    enginesdir.sub!(openssl.prefix.realpath, prefix)

    modulesdir = Utils.safe_popen_read("pkgconf", "--variable=modulesdir", "libcrypto").chomp
    modulesdir.sub!(openssl.prefix.realpath, prefix)

    system "./bootstrap" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-enginesdir=#{enginesdir}",
                          "--with-modulesdir=#{modulesdir}",
                          *std_configure_args
    system "make", "install"
    pkgshare.install "examples/auth.c"
  end

  test do
    system ENV.cc, pkgshare/"auth.c", "-I#{Formula["openssl@3"].include}",
                   "-L#{lib}", "-L#{Formula["openssl@3"].lib}",
                   "-lp11", "-lcrypto", "-o", "test"
  end
end
