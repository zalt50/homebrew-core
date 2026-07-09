class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "945cc68d47ba2817279b5d64c0f9b5edce6849a52ac1a46ba8c3ecaedce35769"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5369e83aa0e5b103b8227e55843b375cec8e6886195f72bf3986e93e537d95f1"
    sha256 cellar: :any, arm64_sequoia: "3a5211740f285a242576ca9acc372ed3922a9575efe71b3c667fc758a2814db7"
    sha256 cellar: :any, arm64_sonoma:  "2e72c871098af6cd63788ae5fdc31f0109fec91bf5bcefbc65fa99898eb4cb58"
    sha256 cellar: :any, sonoma:        "f6f134fa9a26da1ccd3536f7b71142fdcf4991bdc892c046b434575e6329b5c8"
    sha256 cellar: :any, arm64_linux:   "aaac04a5504d7642275519745ae059f9899fb416a449fc8f52f52a9e932324bc"
    sha256 cellar: :any, x86_64_linux:  "536e60457fb1b2ed97a41634b8472c616b6cbbc855a81d7f7f819d1edcae8d3a"
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
