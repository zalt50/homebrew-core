class Cpr < Formula
  desc "C++ Requests, a spiritual port of Python Requests"
  homepage "https://docs.libcpr.org/"
  url "https://github.com/libcpr/cpr/archive/refs/tags/1.14.0.tar.gz"
  sha256 "db9b4d615f71b1dbaa7ee5d972a15001b98100da0cf62fe99249b8eec85eabd8"
  license "MIT"
  head "https://github.com/libcpr/cpr.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "37ad08fc58f3a53c425e9ffcf1f4118d937ad7041de61d45d7af06969cfcf46c"
    sha256 cellar: :any,                 arm64_sequoia: "b4f49c44c7af2a84f22f73e1d12c548a96b16a2e57c82a51e03c268f5c689393"
    sha256 cellar: :any,                 arm64_sonoma:  "2f78a171abb588806831d5f810c1be1d2243a7234163dca49b1f04a1adbaab9d"
    sha256 cellar: :any,                 sonoma:        "f6cd693e2e3b3c94c576278c6d173e50fab8495178e5a0663244059025f6df84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bce11bbeceb0bc7a7db13cb703889561aab1f3d1774e53e5c08771df69acff4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c6dfbd95b5dab11ebeee3e1df53f8e344ef82306a5abd12c6f75d71d624debe"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl", since: :monterey # Curl 7.68+

  on_linux do
    depends_on "openssl@3"
  end

  def install
    args = %W[
      -DCPR_USE_SYSTEM_CURL=ON
      -DCPR_BUILD_TESTS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ] + std_cmake_args

    ENV.append_to_cflags "-Wno-error=deprecated-declarations"
    system "cmake", "-S", ".", "-B", "build-shared", "-DBUILD_SHARED_LIBS=ON", *args
    system "cmake", "--build", "build-shared"
    system "cmake", "--install", "build-shared"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=OFF", *args
    system "cmake", "--build", "build-static"
    lib.install "build-static/lib/libcpr.a"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <curl/curl.h>
      #include <cpr/cpr.h>

      int main(int argc, char** argv) {
          auto r = cpr::Get(cpr::Url{"https://example.org"});
          std::cout << r.status_code << std::endl;

          return 0;
      }
    CPP

    args = %W[
      -I#{include}
      -L#{lib}
      -lcpr
    ]
    args << "-I#{Formula["curl"].opt_include}" if !OS.mac? || MacOS.version <= :big_sur

    system ENV.cxx, "test.cpp", "-std=c++17", *args, "-o", testpath/"test"
    assert_match "200", shell_output("./test")
  end
end
