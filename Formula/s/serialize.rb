class Serialize < Formula
  desc "Single-header bitpacking serializer for C++ aimed at game networking"
  homepage "https://github.com/mas-bandwidth/serialize"
  url "https://github.com/mas-bandwidth/serialize/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "abcf00758f35612678430991ba76cf4254c12627784f681e9a3c3cf08f59d9fd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "722afc95a559bd7585a1be397c0030ce0d2afc18785d440d9db30313d008f78b"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DSERIALIZE_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <serialize.h>
      int main()
      {
          uint8_t buffer[64];
          memset( buffer, 0, sizeof( buffer ) );
          serialize::WriteStream writer( buffer, 64 );
          uint32_t written = 12345;
          writer.SerializeBits( written, 14 );
          writer.Flush();
          serialize::ReadStream reader( buffer, writer.GetBytesProcessed() );
          uint32_t value = 0;
          reader.SerializeBits( value, 14 );
          return value == 12345 ? 0 : 1;
      }
    CPP
    system ENV.cxx, "test.cpp", "-I#{include}", "-o", "test"
    system "./test"
  end
end
