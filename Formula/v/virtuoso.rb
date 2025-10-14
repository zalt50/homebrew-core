class Virtuoso < Formula
  desc "High-performance object-relational SQL database"
  homepage "https://virtuoso.openlinksw.com"
  url "https://github.com/openlink/virtuoso-opensource/releases/download/v7.2.16/virtuoso-opensource-7.2.16.tar.gz"
  sha256 "0a70dc17f0e333d73307c9c46e8a7a82df70a410ddfe027a5bf7ba6c9204a928"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6b9d44b358f8223bf339c745299782a6ca56ff80666fa2e10d45921af0171a63"
    sha256 cellar: :any,                 arm64_sequoia: "554f70d10abdd7c5e5f1c0eed8d202de4e62740bde00ac9d3e26d32168859f6d"
    sha256 cellar: :any,                 arm64_sonoma:  "b2740440db3983362e3543c4642d097c46a7fe318a48e6bf39988cc73089628c"
    sha256 cellar: :any,                 arm64_ventura: "54d673c5a3bded8b8246864ecfee54b8a501a2f88e703fd2c4c0754821e5f0cd"
    sha256 cellar: :any,                 sonoma:        "d0e5dfddf198d9d81c4a62a545cc1791f849c8cb211272b0e361057383339f01"
    sha256 cellar: :any,                 ventura:       "3836ad54c55271fbcf39b080dfb087d392d9ef1ee549713d0550438925d0668c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13cf4c0d1af7fa2ceb8aeab1e3d9ec3dc0c61f73b3f551aaceeeeb9ea4f7353d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c72bb1f9b52ea3ef7efc4609fc07b475ca0a7f51c09cec3770dfa90117685f40"
  end

  head do
    url "https://github.com/openlink/virtuoso-opensource.git", branch: "develop/7"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # If gawk isn't found, make fails deep into the process.
  depends_on "gawk" => :build
  depends_on "openssl@3"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "net-tools" => :build
    depends_on "xz" # for liblzma
  end

  conflicts_with "unixodbc", because: "both install `isql` binaries"

  skip_clean :la

  # Support openssl 3.6, upstream pr ref, https://github.com/openlink/virtuoso-opensource/pull/1364
  patch :DATA

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--without-internal-zlib"
    system "make", "install"
  end

  def caveats
    <<~EOS
      NOTE: the Virtuoso server will start up several times on port 1111
      during the install process.
    EOS
  end

  test do
    system bin/"virtuoso-t", "+checkpoint-only"
  end
end

__END__
diff --git a/configure b/configure
index 2953300..a4c8766 100755
--- a/configure
+++ b/configure
@@ -23182,8 +23182,8 @@ main (void)
 	/* LibreSSL defines OPENSSL_VERSION_NUMBER 0x20000000L but uses a compatible API to OpenSSL v1.0.x */
 	#elif OPENSSL_VERSION_NUMBER < 0x1020000fL
 	/* OpenSSL versions 0.9.8e - 1.1.1 are supported */
-       #elif OPENSSL_VERSION_NUMBER < 0x30600000L
-       /* OpenSSL versions 3.0.x - 3.5.x are supported */
+       #elif OPENSSL_VERSION_NUMBER < 0x30700000L
+       /* OpenSSL versions 3.0.x - 3.6.x are supported */
 	#else
 	#error OpenSSL version too new
 	#endif
