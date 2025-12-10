class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https://thelfer.github.io/tfel/web/index.html"
  url "https://github.com/thelfer/tfel/archive/refs/tags/TFEL-5.0.2.tar.gz"
  sha256 "3ba5ff8d369c15b38a56a1d33d489681ad2d2bb2ec93a67800bb5968cd1e89ec"
  license "GPL-1.0-or-later"
  head "https://github.com/thelfer/tfel.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "da65729946101a094a08bdf88484da80941b8dcd10e6df3e8be2ddef77856b1a"
    sha256 arm64_sequoia: "d8f4566c670b50e71803044ef482f3cbf6edd05f7477cb3e2295262adf842637"
    sha256 arm64_sonoma:  "d2b104c21a79dc7aafbb7cfd951a0bf9584872572016e6b371192f8989c81d9d"
    sha256 sonoma:        "28a3ca566bf9548afa081935a9f21d11e3f14213a79b8e29bc93a78f4a067009"
    sha256 arm64_linux:   "9671f1caabe0f5a693a48f8db0dd6737ab01e256a26793c72c7c96a498a685c0"
    sha256 x86_64_linux:  "a65a73c20aff24cf6c9eaa842ab9458d4193ce7c7e265167eec4533d199ad084"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "pybind11" => :build
  depends_on "python@3.14"

  # Fix to error: assignment of member in read-only object
  # PR ref: https://github.com/thelfer/tfel/pull/894
  patch do
    url "https://github.com/thelfer/tfel/commit/fb5ef740a47f2bef1b0d35b16b79a1fce7439ca9.patch?full_index=1"
    sha256 "bf5581c83529af35ac70687f9195f117c9a655aec3c06c1cea231707f15d4ede"
  end

  def install
    args = [
      "-DUSE_EXTERNAL_COMPILER_FLAGS=ON",
      "-Denable-reference-doc=OFF",
      "-Denable-website=OFF",
      "-Dlocal-castem-header=ON",
      "-Denable-python=ON",
      "-Denable-python-bindings=ON",
      "-Denable-pybind11=ON", # requires pybind11
      "-Denable-numpy-support=OFF",
      "-Denable-fortran=ON",
      "-Denable-cyrano=ON",
      "-Denable-lsdyna=ON",
      "-Denable-aster=ON",
      "-Denable-abaqus=ON",
      "-Denable-calculix=ON",
      "-Denable-comsol=ON",
      "-Denable-diana-fea=ON",
      "-Denable-ansys=ON",
      "-Denable-europlexus=ON",
      "-Denable-testing=OFF",
      "-Dpython-static-interpreter-workaround=ON",
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.mfront").write <<~MFRONT
      @Parser Implicit;
      @Behaviour Norton;
      @Algorithm NewtonRaphson_NumericalJacobian ;
      @RequireStiffnessTensor;
      @MaterialProperty real A;
      @MaterialProperty real m;
      @StateVariable real p ;
      @ComputeStress{
        sig = D*eel ;
      }
      @Integrator{
        real seq = sigmaeq(sig) ;
        Stensor n = Stensor(0.) ;
        if(seq > 1.e-12){
          n = 1.5*deviator(sig)/seq ;
        }
        feel += dp*n-deto ;
        fp -= dt*A*pow(seq,m) ;
      }
    MFRONT
    system bin/"mfront", "--obuild", "--interface=generic", "test.mfront"
    assert_path_exists testpath/"src"/shared_library("libBehaviour")
  end
end
