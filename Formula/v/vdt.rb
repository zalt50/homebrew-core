class Vdt < Formula
  desc "Math library of fast, approximate and vectorisable trascendental functions"
  homepage "https://github.com/dpiparo/vdt"
  url "https://github.com/dpiparo/vdt/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "1820feae446780763ec8bbb60a0dbcf3ae1ee548bdd01415b1fb905fd4f90c54"
  license "LGPL-3.0-or-later"
  head "https://github.com/dpiparo/vdt.git", branch: "master"

  depends_on "cmake" => :build

  uses_from_macos "python" => :build

  def install
    # https://github.com/dpiparo/vdt/issues/21
    args = %w[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]
    args << "-DSSE=OFF" if Hardware::CPU.arm?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cxx").write <<~C
      #include <vdt/cos.h>
      #include <cmath>
      int main() {
          return vdt::fast_cos(0.5) == std::cos(0.5) ? 0 : 1;
      }
    C
    system ENV.cxx, "test.cxx", "-L#{lib}", "-lvdt", "-o", "test"
    system "./test"
  end
end
