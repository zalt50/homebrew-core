class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://libxc.gitlab.io/"
  url "https://gitlab.com/libxc/libxc/-/archive/7.1.1/libxc-7.1.1.tar.bz2"
  sha256 "0e913232757338f345830250bf344d8c60feca5b8ff6c0c6b2229c5189eea11f"
  license "MPL-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "625e98f665c2edb5899737159331b1dd3fd265d4ee9d1ed1c318591515be4a42"
    sha256 cellar: :any, arm64_sequoia: "c7e7b8077fa3ca4dad77ccd1e32764644a13894b2bbd37dd93ac441d7ff4e9b9"
    sha256 cellar: :any, arm64_sonoma:  "7b155b606995e268a26951406ce560a39d9ed2452411e73753ac33fe0fa95b84"
    sha256 cellar: :any, sonoma:        "d073c4ef524d8791a8931aa75cdb0b4e15dee149189ad3fdb4aaebb94122f749"
    sha256 cellar: :any, arm64_linux:   "36adf43849fc68b0d151d8a2f246edeb5adce26ab1e9d239a38a2c5861e1345b"
    sha256 cellar: :any, x86_64_linux:  "305810e2ec329690f0cdf65f7842249059827e2f306a5ee6722e2aa1c061b7b3"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "gcc" # for gfortran

  def install
    args = %w[
      -DENABLE_FORTRAN=ON
      -DDISABLE_KXC=OFF
      -DDISABLE_LXC=OFF
      -DBUILD_SHARED_LIBS=ON
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Common test files for both cmake and plain
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <xc.h>
      int main()
      {
        int major, minor, micro;
        xc_version(&major, &minor, &micro);
        printf("%d.%d.%d", major, minor, micro);
      }
    C
    (testpath/"test.f90").write <<~FORTRAN
      program lxctest
        use xc_f03_lib_m
      end program lxctest
    FORTRAN
    # Simple cmake example
    (testpath / "CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.6)
      project(test_libxc LANGUAGES C Fortran)
      find_package(Libxc CONFIG REQUIRED)
      add_executable(test_c test.c)
      target_link_libraries(test_c PRIVATE Libxc::xc)
      add_executable(test_fortran test.f90)
      target_link_libraries(test_fortran PRIVATE Libxc::xcf03)
    CMAKE
    # Test cmake build
    system "cmake", "-B", "build"
    system "cmake", "--build", "build"
    system "./build/test_c"
    system "./build/test_fortran"
    # Test compilers directly
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lxc", "-o", "ctest", "-lm"
    system "./ctest"
    system "gfortran", "test.f90", "-L#{lib}", "-lxc", "-I#{include}",
                       "-o", "ftest"
    system "./ftest"
  end
end
