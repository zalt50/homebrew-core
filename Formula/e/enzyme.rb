class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.286.tar.gz"
  sha256 "eb4ce40083e7cfefc6a43d39d6636d8fc1a5f787d14048c47c0634de988acd94"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9dda6029983b9f837d5be1d5ed51c6908bbf2f605be0fed4ad7ac2ea589ab5be"
    sha256 cellar: :any, arm64_sequoia: "2a0067ac09b94945817f486afcfbdfdd80bd29d759a56f097e81df43261a2dc0"
    sha256 cellar: :any, arm64_sonoma:  "260f6925ff666630f97f00286c493d5a7c1c1b7e39a9bd9bd8608b3bf82ddfa6"
    sha256 cellar: :any, sonoma:        "247f542c467693b4bd03c67eb6d412e3a4fbcc904833ae2e6f0d70afcb06bb8d"
    sha256 cellar: :any, arm64_linux:   "d82fd5d311224dd9cf740e879083c94091f62d299e4eb88d286dfe6a2d9272db"
    sha256 cellar: :any, x86_64_linux:  "ea5a0879f34f799f19dd18adf6314ea629d1cb09dbcfdb57f90a7c54801756ac"
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
