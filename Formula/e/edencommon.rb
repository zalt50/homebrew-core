class Edencommon < Formula
  desc "Shared library for Watchman and Eden projects"
  homepage "https://github.com/facebookexperimental/edencommon"
  url "https://github.com/facebookexperimental/edencommon/archive/refs/tags/v2026.06.22.00.tar.gz"
  sha256 "469465feabbc3bd0a3d6dd83423baa82ca8d303ee636f3bde3249410d253338b"
  license "MIT"
  compatibility_version 1
  head "https://github.com/facebookexperimental/edencommon.git", branch: "main"

  bottle do
    sha256               arm64_tahoe:   "7a39af88ed6b7eb075f27e87c0426155cc6ebff5e0fe105adfa8ea0ee8ce0851"
    sha256               arm64_sequoia: "f916af69b73010c4bd3ae8e0541205679b60e7b0d801020d65a778fa59fc9bd7"
    sha256               arm64_sonoma:  "c4cf223cfc28ea9200f8d9bacd9e8dcf4f87a966cabc55f04ef413404f8d8ca9"
    sha256 cellar: :any, sonoma:        "9aabc7f71a6ef13d1d1a5c3e507685626715c7ba860823483e7f59a8fdcbbac8"
    sha256 cellar: :any, arm64_linux:   "723f49f37594f5b065b3019e903a3ea723f955f9c254a61569a63ea4acdd4dcc"
    sha256 cellar: :any, x86_64_linux:  "8bfc344e45d01ce8ef0d87421978b18662abed369b866b5b74078553bfb87b5e"
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

  # GCC 13 libstdc++ no longer pulls in <string> via <string_view>.
  # PR ref: https://github.com/facebookexperimental/edencommon/pull/32
  patch do
    url "https://github.com/facebookexperimental/edencommon/commit/7dc082da238446cde535b03370be0b709701b7ac.patch?full_index=1"
    sha256 "1becb3b9bcba13f19cb697baa015bece72b0330e4beae6db5a459f4e6fbff5a5"
  end

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

    system ENV.cxx, "-std=c++20", "-I#{include}", "test.cc",
                    "-L#{lib}", "-L#{formula_opt_lib("folly")}",
                    "-L#{formula_opt_lib("boost")}", "-L#{formula_opt_lib("glog")}", "-L#{formula_opt_lib("fmt")}",
                    "-ledencommon_utils", "-lfolly", "-lfmt", "-lboost_context", "-lglog", "-o", "test"
    assert_match "ruby", shell_output("./test #{Process.pid}")
  end
end
