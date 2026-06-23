class Openturns < Formula
  desc "Probabilistic modelling and uncertainty quantification library"
  homepage "https://github.com/openturns/openturns"
  url "https://github.com/openturns/openturns/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "d623233aee0aa1f0fee204cfc9297f9c910e858af8df2560034c8ad2f2d31adb"
  license "LGPL-3.0-or-later"
  head "https://github.com/openturns/openturns.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "73509d76e28350be11a13e1e605293dcebb5eedaf9a9e1374d0c680ae1115d5c"
    sha256 arm64_sequoia: "ac186f6d821243905b89d963141520ebe032cb52d0f03960c95284612991a20a"
    sha256 arm64_sonoma:  "0162dbcdbdc22be46e9731f2885f2276acd1c3075a150cb9fe08a776accbf6d8"
    sha256 sonoma:        "00f28bf023f1edbe73af4115baef3ab1bf9f52aa291b9f89fa91a8c1bd47a4ea"
    sha256 arm64_linux:   "190c997e30195674fe3c565da537486bfd4e0a3938d0aaf078543dfaa9472421"
    sha256 x86_64_linux:  "0733e8f951c7d1a5a799bd73ebb4eb5a07bec58ebee3badc623d6dc2b4573173"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cminpack"
  depends_on "gmp"
  depends_on "hdf5"
  depends_on "highs"
  depends_on "ipopt"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "muparser"
  depends_on "nanoflann"
  depends_on "nlopt"
  depends_on "pagmo"
  depends_on "primesieve"
  depends_on "spectra"
  depends_on "tbb"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    args = %w[
      -DBUILD_PYTHON=OFF
      -DCMAKE_UNITY_BUILD=ON
      -DCMAKE_UNITY_BUILD_BATCH_SIZE=32
    ]

    args << "-DBLA_VENDOR=#{OS.mac? ? "Apple" : "OpenBLAS"}"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <openturns/OT.hxx>
      #include <iostream>
      int main() {
        OT::Normal distribution(0.0, 1.0);
        std::cout << distribution.getMean()[0] << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp",
           "-I#{include}", "-L#{lib}", "-lOT", "-o", "test"
    assert_equal "0", shell_output("./test").strip
  end
end
