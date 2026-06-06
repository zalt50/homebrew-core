class Direvent < Formula
  desc "Monitors events in the file system directories"
  homepage "https://www.gnu.org.ua/software/direvent/direvent.html"
  url "https://ftpmirror.gnu.org/gnu/direvent/direvent-5.5.tar.gz"
  mirror "https://ftp.gnu.org/gnu/direvent/direvent-5.5.tar.gz"
  sha256 "0e16c0b4b3e6f7673e9b4f31d81ab01236ad22f83538512f3b2f58f9f96fdcb7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "7b48ad09b22f7ce1fc4f6be31312cae2acb2fcb33a52b862e6c442e0bb874f89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f63f471b456241dcf62d3e76ba38a6a32424220eee43665a17eed552ec817fb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afb68e0c1394f2dc09e35f47cae0d7c57b337b4d92766fe3edb018b956628bef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ed0f6f45d7c79bab9b43a70c66a9f42c50c98914d387c7ab88bfb52e043af20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9044f997c251b9d8d188f576b5fc71e8f3e1306f4b2bb86e131eec6d106877ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "93e741a317f67a70c7ec7a51ee68b16b9af06e0038eea6477332543c657246cc"
    sha256 cellar: :any_skip_relocation, ventura:        "55d5411f9552456a39cb6bee0fd86cc40f88a19f6e3deb1fbc52dbe0a63fac5a"
    sha256 cellar: :any_skip_relocation, monterey:       "aa9149e69d6ed55b6a4de7cb345c9202dfb8136197ec40d99d3d9f4d805b3678"
    sha256                               arm64_linux:    "1c64f0b91a2b262581b83717c051b3cc781ab418ed36315c1e81a27e9b06d630"
    sha256                               x86_64_linux:   "c8fb131f7845cd016244b0f5285c3e2ca52efcb52b5c1d2c9a7ac301f5b7152e"
  end

  # Fix macOS build: clock_nanosleep/TIMER_ABSTIME are unavailable.
  # Issue ref: https://puszcza.gnu.org.ua/bugs/index.php?678
  patch :DATA

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/direvent --version")
  end
end

__END__
--- a/src/progman.c
+++ b/src/progman.c
@@ -244,6 +244,32 @@
 	}
 }

+/*
+ * Sleep until the absolute DEADLINE (CLOCK_MONOTONIC).  Returns non-zero if
+ * interrupted by a signal (so the caller loops again), zero once the deadline
+ * is reached.  clock_nanosleep with TIMER_ABSTIME is not available everywhere
+ * (e.g. macOS), so fall back to a relative nanosleep there.
+ */
+static int
+drain_wait(struct timespec *deadline)
+{
+#ifdef TIMER_ABSTIME
+	return clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, deadline, NULL);
+#else
+	struct timespec now, rel;
+	clock_gettime(CLOCK_MONOTONIC, &now);
+	rel.tv_sec = deadline->tv_sec - now.tv_sec;
+	rel.tv_nsec = deadline->tv_nsec - now.tv_nsec;
+	if (rel.tv_nsec < 0) {
+		rel.tv_nsec += NANOSEC;
+		--rel.tv_sec;
+	}
+	if (rel.tv_sec < 0)
+		return 0;
+	return nanosleep(&rel, NULL);
+#endif
+}
+
 void
 process_drain(void)
 {
@@ -263,8 +289,7 @@

 	do {
 		process_cleanup(1);
-	} while (proc_list &&
-		 clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME, &ts, NULL));
+	} while (proc_list && drain_wait(&ts));


 	if (proc_list) {
