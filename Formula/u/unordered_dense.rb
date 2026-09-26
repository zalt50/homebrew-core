class UnorderedDense < Formula
  desc "Hashmap and hashset based on robin-hood backward shift deletion"
  homepage "https://github.com/martinus/unordered_dense"
  url "https://github.com/martinus/unordered_dense/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "e92bc8cd7d9ecab2ecc533ae5d4abe224e5e7eb4ee88a0769590669bfaa5ed6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5bb63d040dd1a39a93838f289310323fa60ce67c7fa9a1d7bc6abb232af33bca"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "example"
  end

  test do
    cp pkgshare/"example/main.cpp", testpath
    system ENV.cxx, "-std=c++17", "main.cpp", "-o", "test"
    system "./test"
  end
end
