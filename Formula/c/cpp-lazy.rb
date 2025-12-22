class CppLazy < Formula
  desc "C++11 (and onwards) library for lazy evaluation"
  homepage "https://github.com/Kaaserne/cpp-lazy"
  url "https://github.com/Kaaserne/cpp-lazy/archive/refs/tags/v9.0.0.tar.gz"
  sha256 "4189f85068073339d9f2dfe3e7b8f928cabe6208df73f4d2c7d62acd81977261"
  license "MIT"
  head "https://github.com/Kaaserne/cpp-lazy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e28490a02ee004b28f274c2bf585135b73cd5f4c92bf2d7e51cf17f6175d2ec7"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "fmt"

  def install
    args = %w[
      -DCPP-LAZY_USE_STANDALONE=ON
      -DCPP_LAZY_USE_INSTALLED_FMT=ON
      -DCPP_LAZY_INSTALL=ON
    ]
    system "cmake", "-S", ".", "-B", "builddir", *args, *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <array>
      #include <iostream>
      #include <sstream>

      #include "Lz/map.hpp"

      int main() {
        std::array<int, 4> arr = {1, 2, 3, 4};
        auto map = lz::map(arr, [](int i) { return i + 1; });

        std::ostringstream oss;
        for (auto it = map.begin(); it != map.end(); ++it) {
          if (it != map.begin()) oss << ' ';
          oss << *it;
        }
        std::cout << oss.str() << std::endl; // == "2 3 4 5"
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++20", "-o", "test"
    assert_match "2 3 4 5", shell_output("./test")
  end
end
