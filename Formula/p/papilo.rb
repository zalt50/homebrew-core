class Papilo < Formula
  desc "Parallel Presolve for Integer and Linear Optimization"
  homepage "https://www.scipopt.org"
  url "https://github.com/scipopt/papilo/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "04e2437c41404782fa31cd74a881b475d75a6e692e4c88a24bf48cf5d263a93d"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "da754d46c250c041cf12a60fdd1884d3992468dcede72a6415566696c1bca6e5"
    sha256 cellar: :any,                 arm64_sequoia: "7777103edae9fff71e0ff26dc43982943679c839046c922b19fa7985e7a64a53"
    sha256 cellar: :any,                 arm64_sonoma:  "ddf9ab7f8febc4832debfbbfe7de9feed110a2e04c98309772fd025b2a1b3e85"
    sha256 cellar: :any,                 sonoma:        "95609e2035153a940f0e62fc4cf22dab6691875ac3954dc39167edea298d8117"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "724e6d10cfea779ec91761dca3040febeb11519dd8c71a2281d97fc05aa1bde9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47394fd9bddd12b1170b3ccf46620c0a42e69af12bb3bf4aa28e95ba5a006591"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gcc"
  depends_on "gmp"
  depends_on "openblas"
  depends_on "tbb"

  def install
    cmake_args = %w[
      -DBOOST=ON
      -DGMP=ON
      -DLUSOL=ON
      -DQUADMATH=ON
      -DTBB=ON
      -DBLA_VENDOR=OpenBLAS
    ]

    system "cmake", "-B", "papilo-build", "-S", ".", *cmake_args, *std_cmake_args
    system "cmake", "--build", "papilo-build"
    system "cmake", "--install", "papilo-build"

    pkgshare.install "test/instances/test.mps"
  end

  test do
    output = shell_output("#{bin}/papilo presolve -f #{pkgshare}/test.mps")
    assert_match "presolving finished after", output
  end
end
