class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.273.tar.gz"
  sha256 "3fd1ed2000307e5d9ef7e2e64ff72c1b2fc025ea001f5d4c84cb423155bbef89"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ecc7313fba242c42d9d6a83202c337cd33193483f40b4242f534dad26a2f9d8d"
    sha256 cellar: :any, arm64_sequoia: "9189a9c8eb92ddfb6355f10b313c986d73a08742ed1f21a52a6b7e8d75ab0c14"
    sha256 cellar: :any, arm64_sonoma:  "0b529a5f962a86cc437a76165120b10b49c27d406679bc017524673945a5720b"
    sha256 cellar: :any, sonoma:        "bc6f457cee8d3c10854cafbfb972ca733300429c155df033f8f85b0210170d8d"
    sha256 cellar: :any, arm64_linux:   "746336bb15cc10e19e70db9be4d0afdbfd3aaa41a077b0159f8d19de21d6523f"
    sha256 cellar: :any, x86_64_linux:  "491d94d402bacca27df179ef5af90299555f518354d9d3bdbfbd3a6777c2a022"
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
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f", i, square(i), i, dsquare(i));
      }
    C

    ENV["CC"] = llvm.opt_bin/"clang"

    plugin = lib/shared_library("ClangEnzyme-#{llvm.version.major}")
    system ENV.cc, "test.c", "-fplugin=#{plugin}", "-O1", "-o", "test"
    assert_equal "square(21)=441, dsquare(21)=42", shell_output("./test")
  end
end
