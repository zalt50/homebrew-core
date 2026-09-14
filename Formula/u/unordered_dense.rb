class UnorderedDense < Formula
  desc "Hashmap and hashset based on robin-hood backward shift deletion"
  homepage "https://github.com/martinus/unordered_dense"
  url "https://github.com/martinus/unordered_dense/archive/refs/tags/v5.0.1.tar.gz"
  sha256 "b79f46db45fd73310211429e5d33da4a579543ac544ae7dc12f8d9a31ad0aea4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5a7d8c1fad0fbb175422976870a9639160c9e291f3f30afed2012142777c776c"
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
