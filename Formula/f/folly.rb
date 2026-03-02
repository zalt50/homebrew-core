class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/refs/tags/v2026.03.02.00.tar.gz"
  sha256 "f2a9bbd4bd36256d4554f9917fcefa9ec356cec637d2a743e01a6a1d569224dc"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e89c848f5ecc2b582cd6f0de58c6408060632a29ee7908eba2a95370888dd4b2"
    sha256 cellar: :any,                 arm64_sequoia: "a3a9644c73a7d11089769aca129156f1622bf2a69fae833f8ce4c4c54d0cb7fb"
    sha256 cellar: :any,                 arm64_sonoma:  "c060c7012cd759ba23000fef82d5ce4ead9dd767df8427f2e58cb2779d126c24"
    sha256 cellar: :any,                 sonoma:        "30a872cf363d30f97c1d7a5fb76b292f3876cafce2e17c4a0eeae4ba49b9f9ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7956a6a6fc872211b52e4f9833e92c90fbf9e475ee167997ad3366605c982dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e01ad159525b43279d1ec39d2340d5ddf6e78acb4c6a542f5d7a6bf310d0407"
  end

  depends_on "cmake" => :build
  depends_on "fast_float" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1100
    # https://github.com/facebook/folly/issues/1545
    cause <<~EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

  # Workaround for arm64 Linux error on duplicate symbols
  # Based on https://github.com/facebook/folly/pull/2562
  patch :DATA

  def install
    args = %w[
      -DFOLLY_USE_JEMALLOC=OFF
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libfolly.a", "build/static/folly/libfollybenchmark.a"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}", "-lfolly", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/folly/external/aor/CMakeLists.txt b/folly/external/aor/CMakeLists.txt
index e07e58745..1429f54e9 100644
--- a/folly/external/aor/CMakeLists.txt
+++ b/folly/external/aor/CMakeLists.txt
@@ -20,6 +20,10 @@
 # Linux ELF directives (.size, etc.) that Darwin's assembler doesn't support
 if(IS_AARCH64_ARCH)
 
+if(BUILD_SHARED_LIBS)
+  set(CMAKE_ASM_CREATE_SHARED_LIBRARY ${CMAKE_C_CREATE_SHARED_LIBRARY})
+endif()
+
 folly_add_library(
   NAME memcpy_aarch64
   SRCS
@@ -34,6 +38,7 @@ folly_add_library(
 
 folly_add_library(
   NAME memcpy_aarch64-use
+  EXCLUDE_FROM_MONOLITH
   SRCS
     memcpy-advsimd.S
     memcpy-armv8.S
@@ -58,6 +63,7 @@ folly_add_library(
 
 folly_add_library(
   NAME memset_aarch64-use
+  EXCLUDE_FROM_MONOLITH
   SRCS
     memset-advsimd.S
     memset-mops.S
