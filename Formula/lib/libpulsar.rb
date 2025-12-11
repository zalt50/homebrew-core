class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://dlcdn.apache.org/pulsar/pulsar-client-cpp-4.0.0/apache-pulsar-client-cpp-4.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-client-cpp-4.0.0/apache-pulsar-client-cpp-4.0.0.tar.gz"
  sha256 "8bad1ed09241ba62daa82b84446b3c45e9de5873c407ef09f533fac0332918bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "06c8b663c02f0aa3885c3e7ae1feec2baa316624356a4d38234a197b08ab2b0b"
    sha256 cellar: :any,                 arm64_sequoia: "b5267dd907569faf3d9247081ac74d87529d8d347886e081c159d9ad614972ce"
    sha256 cellar: :any,                 arm64_sonoma:  "724067279cee63476399ac7dea32dc0ab64767ffa085d008e7858b388dccf2bc"
    sha256 cellar: :any,                 sonoma:        "a0d978207818c07e3e6c42ad8cca01e57d12e3f49007c862eed0840aac9a5823"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddecccac3c8fa766e9ab84a92bfcce2e2e723791e3b8131106a6bca063f36994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40e9c12187756f1a0189c2c735dad6173391de4e674b34683f8fc3bb3c97d36d"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DUSE_ASIO=OFF
    ]
    # Avoid over-linkage to `abseil`.
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "--target", "pulsarShared", "pulsarStatic"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:#{free_port}");
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
