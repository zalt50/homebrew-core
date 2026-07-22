class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://github.com/ompl/ompl/archive/refs/tags/2.0.1.tar.gz"
  sha256 "365f052d5fb4419ed016394ddb26ab83dee6514b90565ad30af044a09b122aef"
  license "BSD-3-Clause"
  head "https://github.com/ompl/ompl.git", branch: "main"

  # We check the first-party download page because the "latest" GitHub release
  # isn't a reliable indicator of the latest version on this repository.
  livecheck do
    url "https://ompl.kavrakilab.org/download.html"
    regex(/href=.*?ompl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9db8d1a17411555b340f9bce884fe93aa94a38e8bd009ae6b15e0fcc74407030"
    sha256 cellar: :any,                 arm64_sequoia: "487f8b2e49e8cc4877a1842ffb50e8e5a738a045bde37baf4ce4719191095718"
    sha256 cellar: :any,                 arm64_sonoma:  "3ce07476679e81cf83e4ab902c9cb7ffe3cac20bb3a572d14a83b0405173c3a9"
    sha256 cellar: :any,                 sonoma:        "183762369e5bc2543905d58a0158bebc8cd6c5b56f912345db7d46d72989d3ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b7975058b695b73d56c8dabfd35031ba8979d0ffc72e77c76e5ddd0aacb1630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e4f7207a2f37310c638a8c09624177d5a9cf154e6379b677acca62426976a1c"
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
