class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.279.tar.gz"
  sha256 "dfaeca55b46acd1d800b8680d554c63f03b7ec2e2a0cef3948740d7d03b1ed99"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "23b8f0d05093ef8803cdb8184dd3e6f5b95149ba344c1fe513ace880887c2e05"
    sha256 cellar: :any, arm64_sequoia: "7f54acbb33eb4501f49524c085eedfd1ed5d6d22949c8933f54e09e65f12e90b"
    sha256 cellar: :any, arm64_sonoma:  "c3466e4843db92a15423d47e60b919d41719f75a5f2426b13f2b5a94e4c5900c"
    sha256 cellar: :any, sonoma:        "afe19adb1151dd244674c63b32478b902277ed6d78c848b54da0869a6c913aa8"
    sha256 cellar: :any, arm64_linux:   "94a2a5588d7a87cd0c976d008da5592df7f31c1d8ea4a88320ba0f813d8d3d5b"
    sha256 cellar: :any, x86_64_linux:  "a2e341fd3e6547889aec214f6cc4df5f91e5d744e0a22db0d39ace2e5d6feaa2"
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
