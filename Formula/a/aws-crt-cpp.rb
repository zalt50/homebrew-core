class AwsCrtCpp < Formula
  desc "C++ wrapper around the aws-c-* libraries"
  homepage "https://github.com/awslabs/aws-crt-cpp"
  url "https://github.com/awslabs/aws-crt-cpp/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "63cfbb2e41a8c0252c6a015240080e324444b98ef6d1b758d0b456a4611a2321"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "57eafb3f442d52316854d9d272932922f8be099ab3caaeb9a1cdb5f4e1040b46"
    sha256 cellar: :any, arm64_sequoia: "f858649407920de4a0e32110c4fce574d6ae624949628477e572784f92335369"
    sha256 cellar: :any, arm64_sonoma:  "3f6468acae75fce6517703415f9ebacccc3e9b3135ace46a00551c699d03a2c8"
    sha256 cellar: :any, sonoma:        "96c0c54cc5ea46e872aa0d8fb846d8f13f2ff3baa8bd2df306c5a8dd31ff70c1"
    sha256 cellar: :any, arm64_linux:   "d2f39e654c9b0a9f9654d9e91b3b11115c3fbf6d986bf13a8369a5efb93bf8e6"
    sha256 cellar: :any, x86_64_linux:  "34a2127f861c573d2ac8f5b9b30cf4e1ab3f390420e43639f2d9ed055c0d5797"
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
