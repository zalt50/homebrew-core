class CppGsl < Formula
  desc "Microsoft's C++ Guidelines Support Library"
  homepage "https://github.com/Microsoft/GSL"
  url "https://github.com/Microsoft/GSL/archive/refs/tags/v4.2.2.tar.gz"
  sha256 "59e2a0a0ea22e8bcf9db2dc4d4bd21212ac6595748295fc27a7e02cf75eac4b5"
  license "MIT"
  head "https://github.com/Microsoft/GSL.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a2345b4b473bab384699e4373258d94f7cd324e147b80304075048a015b6cc1"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DGSL_TEST=false", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <gsl/gsl>
      int main() {
        gsl::span<int> z;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++14"
    system "./test"
  end
end
