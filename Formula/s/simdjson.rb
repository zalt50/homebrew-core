class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "72e003bfa39bc6dad1c8d67ec03c656cc250997f63b51369d6e4c4447b52ed20"
  license "Apache-2.0"
  compatibility_version 4
  head "https://github.com/simdjson/simdjson.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f65b1937926670a2ac00aa255e89e21f1f2a5f5b1e10937fbab881b8c4e79016"
    sha256 cellar: :any, arm64_tahoe:       "3b090455f3b5d364b0969ba70164ea735a9650056160eca7d0d7b01f174f425a"
    sha256 cellar: :any, arm64_sequoia:     "b47122a62bd983e87fdad315488ef349856f7b3d946e6fdbe4ab0d9b9df02342"
    sha256 cellar: :any, arm64_linux:       "0e83d4d87cc6c29e64bb3ddfbe4bea50425fb5c7354b812d5a9add8f5efca992"
    sha256 cellar: :any, x86_64_linux:      "3bd8be3955cb0cee53d65d2b8a75cf8fd2dbb59c2c041fca989cfa7b890bfb1e"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DSIMDJSON_BUILD_STATIC_LIB=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.json").write({ name: "Homebrew", isNull: nil }.to_json)
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <simdjson.h>
      int main(void) {
        simdjson::dom::parser parser;
        simdjson::dom::element json = parser.load("test.json");
        std::cout << json["name"] << std::endl;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11",
           "-I#{include}", "-L#{lib}", "-lsimdjson", "-o", "test"
    assert_equal "\"Homebrew\"\n", shell_output("./test")
  end
end
