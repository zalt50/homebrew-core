class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.42.2.tar.gz"
  sha256 "a9e7914128def09b8364f51ef918ea09fddb2616e92a3df3b93c8c94176d44be"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "22868e5071cabb80917cb203e67b09200bb40a96e57cc4f284d8d4fb3ff68dfa"
    sha256 cellar: :any, arm64_sequoia: "6976f8233e7324db212054e01e3882fad3f9226e5899bd29f8fd9da378ec906d"
    sha256 cellar: :any, arm64_sonoma:  "3afedbfe75289660b31254a38f44e7ac42baa037950dfd206d71a4048e917c9c"
    sha256 cellar: :any, sonoma:        "75c1360ac23039965ddf039777d2d6369d2f2cb1634cf34eabc03483dec04eb1"
    sha256 cellar: :any, arm64_linux:   "31c37cd63b6514b49897e35921806bdb045dce74d54181dd11a17b78047e0106"
    sha256 cellar: :any, x86_64_linux:  "7d5a26bcddc5905b3a849c55aa725990ed3f08c18441aca0d7fa267c417439e2"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-auth"
  depends_on "aws-c-cal"
  depends_on "aws-c-common"
  depends_on "aws-c-event-stream"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-mqtt"
  depends_on "aws-c-s3"
  depends_on "aws-c-sdkutils"
  depends_on "aws-checksums"

  def install
    args = %W[
      -DBUILD_DEPS=OFF
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_MODULE_PATH=#{formula_opt_lib("aws-c-common")}/cmake
    ]
    # Avoid linkage to `aws-c-compression`
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <aws/crt/Allocator.h>
      #include <aws/crt/Api.h>
      #include <aws/crt/Types.h>
      #include <aws/crt/checksum/CRC.h>

      int main() {
        Aws::Crt::ApiHandle apiHandle(Aws::Crt::DefaultAllocatorImplementation());
        uint8_t data[32] = {0};
        Aws::Crt::ByteCursor dataCur = Aws::Crt::ByteCursorFromArray(data, sizeof(data));
        assert(0x190A55AD == Aws::Crt::Checksum::ComputeCRC32(dataCur));
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-L#{lib}", "-laws-crt-cpp"
    system "./test"
  end
end
