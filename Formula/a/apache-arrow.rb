class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-25.0.1/apache-arrow-25.0.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-25.0.1/apache-arrow-25.0.1.tar.gz"
  sha256 "43d5de0a581f43cf63a2c06b4dcf13b9ff6fcd800f023324596e5781093bc500"
  license "Apache-2.0"
  revision 1
  compatibility_version 3
  head "https://github.com/apache/arrow.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ba3fa1e0537b187a30189a2e2c826c8bb2900e818ae6f85c809c2284471a88bb"
    sha256 cellar: :any, arm64_sequoia: "467cf9bb904fe436ca6de1fcc494e97a83062a655864ad4c2f65052d79150238"
    sha256 cellar: :any, arm64_sonoma:  "40e8394ace7add77181dba292128090a726cc51415ef0f1a3bf6cb48e411d0b6"
    sha256 cellar: :any, sonoma:        "70e5f3121071f0d3d846b118bf64a9003bf07da242b4e05ab92b3f4b9e5b7d80"
    sha256               arm64_linux:   "4ec522032d8abc0188fee3a1e4ba4de6630ba928b5bdcf0ec4407ccbb698f212"
    sha256               x86_64_linux:  "ab482e493618e50201b8b8ed17281829de967009438c6d92f699d5a892ab1760"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gflags" => :build
  depends_on "rapidjson" => :build
  depends_on "xsimd" => :build
  depends_on "abseil"
  depends_on "aws-crt-cpp"
  depends_on "aws-sdk-cpp"
  depends_on "brotli"
  depends_on "grpc"
  depends_on "llvm"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "snappy"
  depends_on "thrift"
  depends_on "utf8proc"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :gcc do
    version "12"
    cause "fails handling PROTOBUF_FUTURE_ADD_EARLY_WARN_UNUSED"
  end

  # Apply commit from Debian maintainer's upstream PR to support CPUs older than SSE4.2.
  patch do
    on_intel do
      url "https://github.com/apache/arrow/commit/fe4ed9e5d3aa9ce921ba6ba98b7f1ea678f833a9.patch?full_index=1"
      sha256 "568ea5843d499f972e8861758747701e29e17babf183461bd0479746d03e4380"
      type :unofficial
      resolves "https://github.com/apache/arrow/pull/50547"
    end
  end

  def install
    ENV.runtime_cpu_detection

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLLVM_ROOT=#{formula_opt_prefix("llvm")}
      -DARROW_DEPENDENCY_SOURCE=SYSTEM
      -DARROW_ACERO=ON
      -DARROW_COMPUTE=ON
      -DARROW_CSV=ON
      -DARROW_DATASET=ON
      -DARROW_FILESYSTEM=ON
      -DARROW_FLIGHT=ON
      -DARROW_FLIGHT_SQL=ON
      -DARROW_GANDIVA=ON
      -DARROW_HDFS=ON
      -DARROW_JSON=ON
      -DARROW_ORC=OFF
      -DARROW_PARQUET=ON
      -DARROW_PROTOBUF_USE_SHARED=ON
      -DARROW_S3=ON
      -DARROW_WITH_BZ2=ON
      -DARROW_WITH_ZLIB=ON
      -DARROW_WITH_ZSTD=ON
      -DARROW_WITH_LZ4=ON
      -DARROW_WITH_SNAPPY=ON
      -DARROW_WITH_BROTLI=ON
      -DARROW_WITH_UTF8PROC=ON
      -DARROW_INSTALL_NAME_RPATH=OFF
      -DPARQUET_BUILD_EXECUTABLES=ON
    ]
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac? # Reduce overlinking

    # ARROW_SIMD_LEVEL sets the minimum required SIMD. Since this defaults to
    # SSE4.2 on x86_64, we need to reduce level to match oldest supported CPU.
    # Ref: https://arrow.apache.org/docs/cpp/env_vars.html#envvar-ARROW_USER_SIMD_LEVEL
    #
    # NOTE: Do not remove this while Core 2 is oldest supported CPU
    args << "-DARROW_SIMD_LEVEL=NONE" if Hardware::CPU.intel?

    system "cmake", "-S", "cpp", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "arrow/api.h"
      int main(void) {
        arrow::int64();
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++20", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end
