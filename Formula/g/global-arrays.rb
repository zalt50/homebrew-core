class GlobalArrays < Formula
  desc "Partitioned Global Address Space (PGAS) library for distributed arrays"
  homepage "https://globalarrays.github.io/"
  url "https://github.com/GlobalArrays/ga/releases/download/v5.9.2/ga-5.9.2.tar.gz"
  sha256 "cbf15764bf9c04e47e7a798271c418f76b23f1857b23feb24b6cb3891a57fbf2"
  license "BSD-3-Clause"

  depends_on "cmake" => [:build, :test]
  depends_on "open-mpi"

  # Backport fix for the `ga++` library's CMake configuration
  patch do
    url "https://github.com/GlobalArrays/ga/commit/9f8d8fad67637c75c430a7a3ea887e4115482301.patch?full_index=1"
    sha256 "421d65a117ef3e53899c491ca5887360821170f0f9e735cc15a72efd9fe08882"
  end

  def install
    args = %w[-DENABLE_TESTS=OFF -DENABLE_FORTRAN=OFF]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(FormulaTest C CXX)
      find_package(GlobalArrays REQUIRED)
      add_executable(test test.c++)
      target_link_libraries(test PRIVATE GlobalArrays::ga++)
    CMAKE

    (testpath/"test.c++").write <<~CXX
      #include <ga/ga++.h>
      #include <iostream>

      int main(int argc, char* argv[])
      {
        GA::Initialize(argc, argv);
        if (0 == GA::nodeid())
          std::cout << GA::nodes();
        GA::Terminate();
      }
    CXX

    system "cmake", "."
    system "cmake", "--build", "."
    assert_equal "2", shell_output("mpirun -n 2 ./test")
  end
end
