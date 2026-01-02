class Taskflow < Formula
  desc "General-purpose Task-parallel Programming System using Modern C++"
  homepage "https://github.com/taskflow/taskflow"
  url "https://github.com/taskflow/taskflow/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "0a9e0f700e7750834f717d7523660399ff7ec455e51000009b3e17923c26b80d"
  license "MIT"
  head "https://github.com/taskflow/taskflow.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fec211cfb51a98e86ef5d7f7f710432d5ab50b9c268b7c6f30d28ea51c94ee7e"
  end

  depends_on "cmake" => :build
  depends_on "make" => :build

  def install
    args = %w[
      -DTF_BUILD_EXAMPLES=OFF
      -DTF_BUILD_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "builddir", *args, *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <taskflow/taskflow.hpp>
      int main() {
        tf::Executor executor;
        tf::Taskflow taskflow;
        executor.run(taskflow).wait();
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++20", "-pthread", "-o", "test"
    system "./test"
  end
end
