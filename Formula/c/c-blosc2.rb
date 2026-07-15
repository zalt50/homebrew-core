class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.2.3.tar.gz"
  sha256 "32977709c21f3fec50befa7a031fa624b963427b69d3ffb69c91aadc9279c887"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "85210364bba7838ec118a6ddc388085ace35ee21802bad8589541829f0d29124"
    sha256 cellar: :any, arm64_sequoia: "56d5cb2d55ffb8b2e637f94a95aaec17b9e7dc76eb54ff62fe3ec7eb7c6f40c9"
    sha256 cellar: :any, arm64_sonoma:  "ec13015179d7a07883b90dea2e63abac0f32b6e0e3a06d312b9dd5e3e3fb8f70"
    sha256 cellar: :any, sonoma:        "07da2661ec9ac523f72c13eb6b0a550c8a2c8fa0edb89cd63953fefa5886f4ea"
    sha256 cellar: :any, arm64_linux:   "438938427027713f85f6584c1c76d78fda120c9217fd81069d0bb34fadd9de32"
    sha256 cellar: :any, x86_64_linux:  "966bbee6a8b4a55a8a7f6ce0bd4a028317c25c9695d853397921a3336633060d"
  end

  depends_on "cmake" => :build
  depends_on "lz4"
  depends_on "zstd"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  fails_with :clang do
    build 1400
  end

  def install
    args = %w[
      -DBUILD_TESTS=OFF
      -DBUILD_FUZZERS=OFF
      -DBUILD_BENCHMARKS=OFF
      -DBUILD_EXAMPLES=OFF
      -DBUILD_PLUGINS=OFF
      -DPREFER_EXTERNAL_LZ4=ON
      -DPREFER_EXTERNAL_ZLIB=ON
      -DPREFER_EXTERNAL_ZSTD=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/simple.c"
  end

  test do
    system ENV.cc, pkgshare/"simple.c", "-I#{include}", "-L#{lib}", "-lblosc2", "-o", "test"
    assert_match "Successful roundtrip!", shell_output(testpath/"test")
  end
end
