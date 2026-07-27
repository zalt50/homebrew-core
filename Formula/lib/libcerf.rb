class Libcerf < Formula
  desc "Numeric library for complex error functions"
  homepage "https://jugit.fz-juelich.de/mlz/lib/cerf"
  url "https://jugit.fz-juelich.de/mlz/lib/cerf/-/archive/v3.3/cerf-v3.3.tar.bz2"
  sha256 "ea9ec1e114227d7d90dbf7985c8801d8ac00e2b696a45dd1058b40e80f283882"
  license "MIT"
  version_scheme 1
  compatibility_version 1
  head "https://jugit.fz-juelich.de/mlz/lib/cerf.git", branch: "main"

  livecheck do
    url "https://jugit.fz-juelich.de/api/v4/projects/269/releases"
    regex(/libcerf[._-]v?((?!2\.0)\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c3a49c2f598757609120ae99569565f67e2a1b817cd7a2a8648cbfcf79fb022c"
    sha256 cellar: :any,                 arm64_sequoia: "a533115d2cc04cf3b55b2cfcea18d40bfb9e60c48bd84b4c7d15f520fbaf55df"
    sha256 cellar: :any,                 arm64_sonoma:  "b0a676b18a17826dfc57958aa8b700c307d21fe3f8f510276b75b4d8b5f8d41d"
    sha256 cellar: :any,                 sonoma:        "0954bcc977146151fed6268836c9ebb1ca199aa09d500d769546da54131c2c2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f32ea4a843889204e68320fac5815758680c994ad607abeb735f7e2f44c944bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08a45c344ce19f291d6cb74c5c89eb461caa4f56c71f5d00637a8dde5945e0f4"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <cerf.h>
      #include <complex.h>
      #include <math.h>
      #include <stdio.h>
      #include <stdlib.h>

      int main (void) {
        double _Complex a = 1.0 - 0.4I;
        a = cerf(a);
        if (fabs(creal(a)-0.910867) > 1.e-6) abort();
        if (fabs(cimag(a)+0.156454) > 1.e-6) abort();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcerf", "-o", "test"
    system "./test"
  end
end
