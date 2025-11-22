class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.218.tar.gz"
  sha256 "7fa61ea0583f74053ab748fb7c15a551d239c817c48d85ffec1c6a9abb48121a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bc2a533b60e63c1173cf29e6d77ddfd695c09520724b464e70ec1ba630ded377"
    sha256 cellar: :any,                 arm64_sequoia: "8c133a59f097b940365ba5d4a88e9d43610093cc7cc12206ab3637d99751b10b"
    sha256 cellar: :any,                 arm64_sonoma:  "8d109e147816d0803c9e7045fa0703f463ed4fc4f619d5da53a0c8b3c6d48599"
    sha256 cellar: :any,                 sonoma:        "1e2970eed52d23f1d4f67dee826481e49e0807272313884cc1ee20d5b37159b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c31057b2513876f8cb94a943cd5c2a6980b017bdc401a46c858e20a76ee8537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfbb238bfb98469a0bdffa28faff5fd6af5b8d692eaedf37e738cfbabcc68003"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    system "cmake", "-S", "enzyme", "-B", "build", "-DLLVM_DIR=#{llvm.opt_lib}/cmake/llvm", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      extern double __enzyme_autodiff(void*, double);
      double square(double x) {
        return x * x;
      }
      double dsquare(double x) {
        return __enzyme_autodiff(square, x);
      }
      int main() {
        double i = 21.0;
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f\\n", i, square(i), i, dsquare(i));
      }
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c",
                        "-fplugin=#{lib/shared_library("ClangEnzyme-#{llvm.version.major}")}",
                        "-O1", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
