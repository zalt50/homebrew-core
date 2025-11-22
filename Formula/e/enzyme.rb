class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.220.tar.gz"
  sha256 "96526a1bfeba6d5ef504e08b420c6c3fa356c8a2011f9c9dbf5d1dff844f263d"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b9d3fd3c489792505502b5d5ee47932b05698d548387daeba9acf53b3ec748e"
    sha256 cellar: :any,                 arm64_sequoia: "1339751fb21547e2d4ddb4b376acbe5311043faaa2a9c3c55de75c6608f89acb"
    sha256 cellar: :any,                 arm64_sonoma:  "9e1c173c803d72f1bb8309401c4de471a426931f587896aaebc4621a5ad534e1"
    sha256 cellar: :any,                 sonoma:        "726d7834f1bfb855a518bdd61106c551839c22415d8f89f356d45e7c081ba38d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42070e67f5e30c1b8bf565e309fde2f69f90a0c110f495bac9809727f0fac714"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d3def33627a2aff6f383e9db906271f7bbdd72f207a2661327cc80bc8691edb"
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
