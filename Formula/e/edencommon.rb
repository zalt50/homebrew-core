class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2026.03.02.00.tar.gz"
  sha256 "9d8a1cee7f5e95b11f67b7b553940b9e578eb699a33c5a75427b45b8172f8f4c"
  license "MIT"
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "ff942a530e45fb9f08635976fab75a51051f3a4df8b0bc40c95905d912bf69c5"
    sha256                               arm64_sequoia: "422a39ee2415e2b4be9469c4a3f58c4d814aa24746d78b26286d540f64889ab6"
    sha256                               arm64_sonoma:  "49e25ce35016c1b3f96cc5357a4214fbe642e7ffb384486d2e339ca0652330a0"
    sha256 cellar: :any,                 sonoma:        "f4b2e78e855180b5839b6a9d942f88c55de21d7a682714848a69b393672fb729"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7f762271950bf4220b9d53e9531f1b6c46af0fc792d9691960b7234de1ecaec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0269aa5d2ab3b0d02cfca1d218696098348194210562eb58184af593900ff264"
  end

  depends_on "cmake" => :build
  depends_on "fbthrift" => :build
  depends_on "gflags" => :build
  depends_on "glog" => :build
  depends_on "googletest" => :build
  depends_on "mvfst" => :build
  depends_on "wangle" => :build
  depends_on "boost"
  depends_on "fb303"
  depends_on "fmt"
  depends_on "folly"

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    # Related: https://gitlab.kitware.com/cmake/cmake/-/issues/26773
    test_cmakelists = %w[
      eden/common/os/test/CMakeLists.txt
      eden/common/utils/test/CMakeLists.txt
    ]
    inreplace test_cmakelists, /(gtest_discover_tests\(.*)\)/, "\\1 DISCOVERY_TIMEOUT 60)"

    # Avoid having to build FBThrift py library
    inreplace "CMakeLists.txt", "COMPONENTS cpp2 py)", "COMPONENTS cpp2)"

    shared_args = %W[
      -DCMAKE_CXX_STANDARD=20
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup -Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "_build", *shared_args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <eden/common/utils/ProcessInfo.h>
      #include <cstdlib>
      #include <iostream>

      using namespace facebook::eden;

      int main(int argc, char **argv) {
        if (argc <= 1) return 1;
        int pid = std::atoi(argv[1]);
        std::cout << readProcessName(pid) << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++17", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{Formula["folly"].opt_lib}",
                    "-L#{Formula["boost"].opt_lib}", "-L#{Formula["glog"].opt_lib}", "-L#{Formula["fmt"].opt_lib}",
                    "-ledencommon_utils", "-lfolly", "-lfmt", "-lboost_context", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end
