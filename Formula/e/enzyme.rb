class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.237.tar.gz"
  sha256 "4d09097ae8b7b6ab85d6faba0fd8a969db01b2e2c9a670487a35240e30787063"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "31ce6349536a335f876cb7220a035b449e4d18a95f97c98e8c2ef023cf12b272"
    sha256 cellar: :any,                 arm64_sequoia: "771813247c875e13fcb278679c1949150e88c6739f3915fa059c009dca68d14a"
    sha256 cellar: :any,                 arm64_sonoma:  "19e1e298873926c1738d3abd3c390208194dc6fbab21fbcc507174de5a949157"
    sha256 cellar: :any,                 sonoma:        "b2e19322e160387b2244b409a376bc18b4f709057439f472c9214162585e0034"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a6e8709f72b8e5946ff8a558c36aab2864ab8dbec9c835284f48bae3d4d84c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37fc234b3e084b4762c374b4ad2c6aa0b5cf92a95b3ad8f0bf05fd77f9a3eac1"
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
