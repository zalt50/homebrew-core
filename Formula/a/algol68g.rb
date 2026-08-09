class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://algol68genie.nl/en/algol-68-genie/"
  url "https://algol68genie.nl/algol68g-3.13.0.tar.gz"
  sha256 "ad05fee71566a1432132d53e0a6b0a2abfd993be73927cfa088b21b3a2d4be56"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "463f9508cef7604ddb5333aa0991933854a7fd0c9ee581784cc801785b5822a8"
    sha256 arm64_sequoia: "c00b1747572a60081eaf58e4409d6bcfe26fd70fea5daed1f4e367edbbce4789"
    sha256 arm64_sonoma:  "ef9b58b5527d9a5a9a84fb5f480d91f513f36ef1d172c132315c4378db1cd63d"
    sha256 sonoma:        "cb40e038754e465c6af5b20113dbc1162022861fe2d6e756fea854fa93b34ec8"
    sha256 arm64_linux:   "a5df625d2e5f14c5123d802a51b75807be228664226f279d1906ee824267cf2a"
    sha256 x86_64_linux:  "bcdae10fdbbe673762a44628a248b5c750a34e172fe4f6d72f35b499b167f7dd"
  end

  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libpq"
  end

  # Use `__BYTE_ORDER__` macro instead of `__BYTE_ORDER`
  patch :DATA

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~ALGOL
      print("Hello World")
    ALGOL

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end

__END__
diff --git a/src/a68g/rts-sounds.c b/src/a68g/rts-sounds.c
index d23509b..b5fef13 100644
--- a/src/a68g/rts-sounds.c
+++ b/src/a68g/rts-sounds.c
@@ -34,10 +34,10 @@
 #undef A68G_LITTLE_ENDIAN
 #undef A68G_BIG_ENDIAN
 #if defined (__BYTE_ORDER__)
-  #if (__BYTE_ORDER == __ORDER_LITTLE_ENDIAN__)
+  #if (__BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__)
     #define A68G_LITTLE_ENDIAN A68G_TRUE
     #define A68G_BIG_ENDIAN A68G_FALSE
-  #elif (__BYTE_ORDER == __ORDER_BIG_ENDIAN__)
+  #elif (__BYTE_ORDER__ == __ORDER_BIG_ENDIAN__)
     #define A68G_LITTLE_ENDIAN A68G_FALSE
     #define A68G_BIG_ENDIAN A68G_TRUE
   #else
