class Esbmc < Formula
  desc "Efficient SMT-based context-bounded model checker for C, C++, and Python"
  homepage "https://esbmc.github.io/"
  url "https://github.com/esbmc/esbmc/archive/refs/tags/v8.4.tar.gz"
  sha256 "9959fef848ffae597adac6fa2d74063f9553b4fcee93ed7cbe8aae3bd667bf91"
  license "Apache-2.0"
  revision 4
  head "https://github.com/esbmc/esbmc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5515e8674896e3613b653600ae8b75f932fe1cd95a0194bd1b595d07039ca314"
    sha256 cellar: :any, arm64_sequoia: "6f333b553fe7d58087106ec124ce31bf06ee9f9bf049ea6ccc7aa26793a71e2d"
    sha256 cellar: :any, arm64_sonoma:  "ef2656ecd7c1ac7786a31efa569f0e94c2094141f6432851271db95e6ece4632"
    sha256 cellar: :any, sonoma:        "a348787f11a866c489c10d8f7d9d9f3ae0ca6c78c7a48f30f7dd7278a85614f8"
    sha256 cellar: :any, arm64_linux:   "533b1fdf752af8bcb8e93b5f7ba299ddb121a7e0bd3583e46e29603a557c5d88"
    sha256 cellar: :any, x86_64_linux:  "b70b810829bb1c4c2089def051a74889f4c3ab94a32db9b537243c5b0bf42eda"
  end

  depends_on "bison" => :build # macOS ships 2.3; esbmc requires >= 2.6.1
  depends_on "cmake" => :build
  depends_on "immer" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build
  depends_on "bitwuzla"
  depends_on "boost"
  depends_on "fmt"
  depends_on "gmp"
  depends_on "llvm@22"
  depends_on "python@3.14"
  depends_on "yaml-cpp"
  depends_on "z3"

  uses_from_macos "flex" => :build

  def install
    python3 = which("python3.14")

    args = %W[
      -DLLVM_DIR=#{formula_opt_lib("llvm@22")}/cmake/llvm
      -DClang_DIR=#{formula_opt_lib("llvm@22")}/cmake/clang
      -DPython3_EXECUTABLE=#{python3}
      -DBitwuzla_DIR=#{formula_opt_prefix("bitwuzla")}
      -DENABLE_PYTHON_FRONTEND=ON
      -DENABLE_FUZZER=OFF
      -DENABLE_Z3=ON
      -DZ3_DIR=#{formula_opt_lib("z3")}/cmake/z3
      -DENABLE_BOOLECTOR=OFF
      -DENABLE_BITWUZLA=ON
      -DENABLE_GOTO_CONTRACTOR=OFF
      -DBUILD_STATIC=OFF
    ]
    args << "-DC2GOTO_SYSROOT=#{MacOS.sdk_path}" if OS.mac?
    args << "-DENABLE_BUNDLE_LIBC_32BIT=OFF" if OS.linux?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      int main() {
        int x = 5;
        assert(x == 5);
        return 0;
      }
    C
    output = shell_output("#{bin}/esbmc #{testpath}/test.c --no-bounds-check --no-pointer-check 2>&1")
    assert_match "VERIFICATION SUCCESSFUL", output

    (testpath/"test.py").write <<~PYTHON
      value = 5
      assert value != 5
    PYTHON
    output = shell_output("#{bin}/esbmc #{testpath}/test.py 2>&1", 1)
    assert_match "VERIFICATION FAILED", output
  end
end
