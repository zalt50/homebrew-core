class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  license "BSD-2-Clause"
  revision 3
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "devel"

  stable do
    url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.12.0/eigenpy-3.12.0.tar.gz"
    sha256 "e6b7f17e1b7fb61e52447ceee8f47c3fc2c8f9cc4d19317e0467dc71babdb350"

    # Backport support for eigen 5.0.0
    patch do
      url "https://github.com/stack-of-tasks/eigenpy/commit/0bb71c7da9c297a334f2de419df13ba2c7a67312.patch?full_index=1"
      sha256 "812274fc7fa68e3af3ede5324590aa2e7ae06f264ac1927989dfe6e324374791"
    end
    patch do
      url "https://github.com/stack-of-tasks/eigenpy/commit/a64334c3ddbdd9ffd9f3b65a0b9c1e0d1d2b8c96.patch?full_index=1"
      sha256 "2110114b6467e5e2889ea55b9e3b2ef5f8cc965a914bfd62d2335e526551d421"
    end
    patch do
      url "https://github.com/stack-of-tasks/eigenpy/commit/2a4adb8af92eebd1dac321010db040797100b91d.patch?full_index=1"
      sha256 "ef47a99123a391c6d3a7be683d5667b3d2f94562d1b4a6c8284c8acc1928b4c2"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5dba4558782405576b2cb6764135000d9a4cad5cf38e500a4a1f3f8dd612063c"
    sha256 cellar: :any,                 arm64_sequoia: "95797a7a45aa19440352ab14e0f1920135961f6d435cbb0c9f498c98c4c50581"
    sha256 cellar: :any,                 arm64_sonoma:  "3a4339729cbcafebc07c2b2ed45aa5f18f02fba8ab78dbbdb9918fcdbb773543"
    sha256 cellar: :any,                 sonoma:        "a287960361234bde9ee9c17481222d81b4231eb67ec80314a77ae0089ce8df90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9abf2e0f4f9b183f5872193216ef47e0370a5a4ba298e61b90288cad3a6320c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f48af78a3b5b26b468884fdee921e7b2c322defbd51a7a8dfacbc7277f633e1b"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.14"
  depends_on "scipy"

  def python3
    "python3.14"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    args = %W[
      -DPYTHON_EXECUTABLE=#{which(python3)}
      -DBUILD_UNIT_TESTS=OFF
    ]
    # Avoid linkage to boost container and graph modules
    # Issue ref: https://github.com/boostorg/boost/issues/985
    args += %w[MODULE SHARED].map { |type| "-DCMAKE_#{type}_LINKER_FLAGS=-Wl,-dead_strip_dylibs" } if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~PYTHON
      import numpy as np
      import eigenpy

      A = np.random.rand(10,10)
      A = 0.5*(A + A.T)
      ldlt = eigenpy.LDLT(A)
      L = ldlt.matrixL()
      D = ldlt.vectorD()
      P = ldlt.transpositionsP()

      assert eigenpy.is_approx(np.transpose(P).dot(L.dot(np.diag(D).dot(np.transpose(L).dot(P)))),A)
    PYTHON
  end
end
