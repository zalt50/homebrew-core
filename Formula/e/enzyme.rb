class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.211.tar.gz"
  sha256 "c6ba1fadbc24ef9fe5110b5f72b8d086b53237411701619474a2369936a72712"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "82d7d17c94367942b9310dee4d9d6463cce5975ea9679e9380183fef416767b6"
    sha256 cellar: :any,                 arm64_sequoia: "c79a983ece28e6dde649e9a83e2795fe285ec3e882aa6e161993bb93c853a01b"
    sha256 cellar: :any,                 arm64_sonoma:  "d6470006c5159e1bfa5dda74e2bf88efdaf05e112f355f5596d814cb9f2bc53e"
    sha256 cellar: :any,                 sonoma:        "c6f2a7861e77bffcf04235f55cb15ff22f8cf2876f5f79be4c46405610141650"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f96d2b01a057f37a8850771a90074917481a716eaabdb83c55f236c357c9b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69c8eddecfacd660d6e5fd8cac378de8e6831a041838dc9f4f9b32b5f624af91"
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
