class UnorderedDense < Formula
  desc "Hashmap and hashset based on robin-hood backward shift deletion"
  homepage "https://github.com/martinus/unordered_dense"
  url "https://github.com/martinus/unordered_dense/archive/refs/tags/v4.9.1.tar.gz"
  sha256 "02d062c0238215bd842328e6544dcd02801645e7d9c224b113890aff80194fa3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2ef183b8003d56897171d533bfe38d7c6cf801d8e47085b7026dd9225795101e"
  end

  depends_on "cmake" => :build

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
