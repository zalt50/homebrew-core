class Crow < Formula
  desc "Fast and Easy to use microframework for the web"
  homepage "https://crowcpp.org"
  url "https://github.com/CrowCpp/Crow/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "a485c2d27d98b85655f4b8b5628aeab847bae10a41b89b07a8fb7aae52c0298f"
  license "BSD-3-Clause"
  head "https://github.com/CrowCpp/Crow.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "97c63829c1a1d5eb88a3f75fa7e924bd424fd92c97b33d6f5c147dedf43748d5"
  end

  depends_on "cmake" => :build
  depends_on "asio"

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DCROW_BUILD_EXAMPLES=OFF", "-DCROW_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <crow.h>
      int main() {
        crow::SimpleApp app;
        CROW_ROUTE(app, "/")([](const crow::request&, crow::response&) {});
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test"
    system "./test"
  end
end
