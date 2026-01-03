class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.233.tar.gz"
  sha256 "64cfb18aa3179bd8ed9835d7aa55e3982faf597f3592262f9711bbb6662285ed"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4abc367aee687092e4853327c38dab69f96ec9477969e191ca0b6a65198026e1"
    sha256 cellar: :any,                 arm64_sequoia: "59387c5ace6091991839b4b95b4d2b5b46d2e3550f1912e6f0909766d624734f"
    sha256 cellar: :any,                 arm64_sonoma:  "5e7f9cb9f9a71cb824f1b39e895ae2fcff05787c43ecb5c160b3a0e22fa04f6f"
    sha256 cellar: :any,                 sonoma:        "8514c61c53cb1f7c67ff58bb087b134eecb5eb8040e4f962696fbd1ef98fa6ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97af9d284ad049112614262990c103ef3b9cc655a2396ebc3ff0afe3d1e26576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fabc0373e85d68d36ae53c1fa5583b4ce7bc07ce216e01d1bea3498de32d0c09"
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
