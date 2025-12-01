class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/EnzymeAD/Enzyme/archive/refs/tags/v0.0.226.tar.gz"
  sha256 "aa2d67ee50a62d490b319013617d6dba4017b250de4a3061748370cfb0ab0791"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/EnzymeAD/Enzyme.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0490bba94cdbda6ded0d9fb1172bd5c3c320c6e6ad17ab1c5c9458ebea6ace31"
    sha256 cellar: :any,                 arm64_sequoia: "844e955f45ef264cef88cf3086bb39a61d4d4e98a971cf46cc044f7d7bfc6df0"
    sha256 cellar: :any,                 arm64_sonoma:  "803cc8584cf60330e69ebbd9107d498295cbfa5f9bb2259d746da0a0b2f106b7"
    sha256 cellar: :any,                 sonoma:        "ae4219f24c07cd897cdfe9d6b401a145eca40ee7c5b569602df13e8c3ecdaac4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66813e1a8531c43ef5a511bafa927e3778c70c5cd30ae94ed12af650b2a882e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff36900415518b3c9d712436352e82ba366687afb30cf2d3d128d3c16ea25070"
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
