class Doctest < Formula
  desc "Feature-rich C++11/14/17/20/23 single-header testing framework"
  homepage "https://github.com/doctest/doctest"
  url "https://github.com/doctest/doctest/archive/refs/tags/v2.5.3.tar.gz"
  sha256 "174ebc4e769928959614789c5b4e9c3d0a0f81a62bb608756b127bfebfb21331"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "327aba0814a710bea52f932aec32c4843540b648b99a3c4c638c7d8ef9aec576"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DDOCTEST_WITH_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
      #include <doctest/doctest.h>
      TEST_CASE("Basic") {
        int x = 1;
        SUBCASE("Test section 1") {
          x = x + 1;
          REQUIRE(x == 2);
        }
        SUBCASE("Test section 2") {
          REQUIRE(x == 1);
        }
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
