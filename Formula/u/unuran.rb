class Unuran < Formula
  desc "UNU.RAN - Universal Non-Uniform RANdom number generator"
  homepage "https://statmath.wu.ac.at/unuran/"
  url "https://github.com/unuran/unuran/archive/refs/tags/unuran-1.11.0.tar.gz"
  sha256 "e46c15eff050150966988ec56969526b60ce0b97120a7821aa96703d0f175623"
  license "GPL-2.0-or-later"
  head "https://github.com/unuran/unuran.git", branch: "main"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "texinfo" => :build
  depends_on "gsl"

  def install
    # force autogen.sh to look for and use our glibtoolize
    inreplace "autogen.sh", "libtoolize", "glibtoolize"
    system "./autogen.sh", "--enable-shared", "--with-urng-gsl", *std_configure_args
    system "make"
    # system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <unuran.h>
      int main() {
          UNUR_DISTR *par = unur_distr_normal(NULL, 0);
          if (par == NULL) return 1;
          return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{Formula["gsl"].opt_lib}", "-L#{lib}",
            "-lgsl", "-lgslcblas", "-lunuran", "-o", "test"
    system "./test"
  end
end
