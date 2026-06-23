class Openturns < Formula
  desc "Probabilistic modelling and uncertainty quantification library"
  homepage "https://github.com/openturns/openturns"
  url "https://github.com/openturns/openturns/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "d623233aee0aa1f0fee204cfc9297f9c910e858af8df2560034c8ad2f2d31adb"
  license "LGPL-3.0-or-later"
  head "https://github.com/openturns/openturns.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "514290aa010de74a1d37399c96ac1dedd0b454f908703a2e6ac4d2a52e459ca5"
    sha256 arm64_sequoia: "ae9d55444d0943d38a2a3042e190eb01f3bc31a542268b8d38931627170ed772"
    sha256 arm64_sonoma:  "3fd5beea88a176ca6adbc932a0404493d326adde45aa8b8e9cf1bee873555f17"
    sha256 sonoma:        "8bafa88f02605a59cea5a842c84dfccbe90d78e85bd82f01dcd90eca267f6bae"
    sha256 arm64_linux:   "7c528051d44e738eff1f2e139cda7229ada842baf45a57d493c7e0673716be8d"
    sha256 x86_64_linux:  "4123a31093a55a07f41d155cb350d3fb8ab3fc72c66e708491800b6b84d05916"
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
