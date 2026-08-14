class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://github.com/ompl/ompl/archive/refs/tags/2.0.1.tar.gz"
  sha256 "365f052d5fb4419ed016394ddb26ab83dee6514b90565ad30af044a09b122aef"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/ompl/ompl.git", branch: "main"

  # We check the first-party download page because the "latest" GitHub release
  # isn't a reliable indicator of the latest version on this repository.
  livecheck do
    url "https://ompl.kavrakilab.org/download.html"
    regex(/href=.*?ompl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a4900cd087705050cf4365995825a5e3d74a141fb832528527e84f44429e4afd"
    sha256 cellar: :any, arm64_sequoia: "260e09a4daa5ecff1e929a12363894ad159918ec74b2e955b985159fff47db11"
    sha256 cellar: :any, arm64_sonoma:  "b4f4437ab76e1a21d4d5c66b75e5b9e9997ea0be969c6f5ed8ed661deece26a1"
    sha256 cellar: :any, sonoma:        "38708b26b46a5fb649a8fbd0ea048aa08af065fb6aad9fcc00c8b24128e6e0f7"
    sha256 cellar: :any, arm64_linux:   "02df1d8624f5911f9a85bd1452b6fec857983f5eae37dce0f41185981e689e07"
    sha256 cellar: :any, x86_64_linux:  "bb093a7c3abad0dd973acd8f01191a0768a6ce6ba8fae768d9a8aa7b6b6f2a00"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "flann"
  depends_on "ode"

  def install
    args = %w[
      -DOMPL_REGISTRATION=OFF
      -DOMPL_BUILD_DEMOS=OFF
      -DOMPL_BUILD_TESTS=OFF
      -DOMPL_BUILD_PYBINDINGS=OFF
      -DOMPL_BUILD_PYTESTS=OFF
      -DCMAKE_DISABLE_FIND_PACKAGE_spot=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_Triangle=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ompl/base/spaces/RealVectorBounds.h>
      #include <cassert>
      int main(int argc, char *argv[]) {
        ompl::base::RealVectorBounds bounds(3);
        bounds.setLow(0);
        bounds.setHigh(5);
        assert(bounds.getVolume() == 5 * 5 * 5);
      }
    CPP

    system ENV.cxx, "test.cpp", "-I#{include}/ompl-#{version.major_minor}", "-L#{lib}", "-lompl", "-o", "test"
    system "./test"
  end
end
