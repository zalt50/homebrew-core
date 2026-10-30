class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.5.10.tar.gz"
  sha256 "b05e47734e2e39c0b00511ed6dc22e71f1b5bf7864b86280653a5128d171c0ed"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1ca04e6a45ab219e7014de0d0e783ba7cd502f343c68d7a6ac39089fed4487d0"
    sha256 cellar: :any, arm64_tahoe:       "b0ac13799809a3bed63b77c36400b377b0bedd2ece63eca14c00befb57f24343"
    sha256 cellar: :any, arm64_sequoia:     "ff9b6b6bb6bcef204a321f231cee36b1882e48d44d63244f6e44e7365c8f2bd9"
    sha256 cellar: :any, arm64_linux:       "8987337b1b8b2ee04bdcd3a0ea46e3c0375ab74f3d8e58236f372e6439cd4fba"
    sha256 cellar: :any, x86_64_linux:      "fc5391fb1f18a63f211a654cfacc78fbee97e16df5d429a1ade4f25d2f9a635d"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  deny_network_access!

  def install
    cmake_args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DUA_ENABLE_DISCOVERY=ON
      -DUA_ENABLE_HISTORIZING=ON
      -DUA_ENABLE_JSON_ENCODING=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <open62541/client_config_default.h>
      #include <assert.h>

      int main(void) {
        UA_Client *client = UA_Client_new();
        assert(client != NULL);
        return 0;
      }
    C
    system ENV.cc, "./test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lopen62541"
    system "./test"
  end
end
