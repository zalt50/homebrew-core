class Safestringlib < Formula
  desc "Safe string operations and memory routines"
  homepage "https://github.com/intel/safestringlib"
  url "https://github.com/intel/safestringlib/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "29a97a4f385172cd72326cb52e58b3b010c3148e741c7685ff3937d92ce516c8"
  license "MIT"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <safe_lib.h>

      int main()
      {
        memzero_s(NULL, 1);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lsafestring_shared", "-o", "test"
    system "./test"
  end
end
