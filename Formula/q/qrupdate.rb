class Qrupdate < Formula
  desc "Fast updates of QR and Cholesky decompositions"
  homepage "https://gitlab.mpi-magdeburg.mpg.de/koehlerm/qrupdate-ng"
  url "https://gitlab.mpi-magdeburg.mpg.de/koehlerm/qrupdate-ng/-/archive/v1.2.0/qrupdate-ng-v1.2.0.tar.bz2"
  sha256 "d3bea4ceafd7b1641ca74c50b74060aeacd7a3cb9ff4159a92aad9c262c57666"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c305f32f4639a5bfeab6e16899d57b376ab2a0189d83ca0a5c89addd61839f9"
    sha256 cellar: :any,                 arm64_sequoia: "b5a428039a1d6c17443eabf02c6273d8a2a753079b4155c8f3eee289363f3210"
    sha256 cellar: :any,                 arm64_sonoma:  "b118290be4e025f4b887416a344c2c382a9349f6766cfed8310d02a14762694a"
    sha256 cellar: :any,                 sonoma:        "c74d34091a406df0680a9d1d208aea0a28ecf43c8552402eb5b1ee83d13d431f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b7905dc60adfb1d09b1fc453916fd4b4040c65c3cb08bdc33bdfca133a77f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ccc86cd597cfb5746a133ec69dca7e2745106447ac9dcc586b21c862e8d252f"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test/tch1dn.f90", "test/utils.f90"
  end

  test do
    system "gfortran", "-o", "test", pkgshare/"tch1dn.f90", pkgshare/"utils.f90",
                       "-fallow-argument-mismatch",
                       "-I#{include}/qrupdate",
                       "-L#{lib}", "-lqrupdate",
                       "-L#{formula_opt_lib("openblas")}", "-lopenblas"
    assert_match "PASSED   4     FAILED   0", shell_output("./test")
  end
end
