class UnorderedDense < Formula
  desc "Hashmap and hashset based on robin-hood backward shift deletion"
  homepage "https://github.com/martinus/unordered_dense"
  url "https://github.com/martinus/unordered_dense/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "541a96c4227b32c0001d90e4c2b3373fe1e7004fd59a64f2667d6e490cdcdb88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "924e37064ca4505e25484bf08569e26448bf588b6d61468aa94fd21a68a28524"
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
