class Lz4 < Formula
  desc "Extremely Fast Compression algorithm"
  homepage "https://lz4.github.io/lz4/"
  url "https://github.com/lz4/lz4/archive/refs/tags/v1.10.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/lz4-1.10.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/lz4-1.10.0.tar.gz"
  sha256 "537512904744b35e232912055ccf8ec66d768639ff3abe5788d90d792ec5f48b"
  license "BSD-2-Clause"
  head "https://github.com/lz4/lz4.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "5dcf512afe9a65da27e9ef33ab6b8069b9bd2950290da3d61a670b4bebb03e83"
    sha256 cellar: :any, arm64_tahoe:       "538e2d6b920b663fcad6b99c1eb294c1157ea9a35d7a50bf0c632df4f427bdf5"
    sha256 cellar: :any, arm64_sequoia:     "97e9c430fd82ccaaf619accc534157e9adfe2f2742ee7c47bfc481b3660b5d3f"
    sha256 cellar: :any, arm64_sonoma:      "bad7f434a13146990b5a021a020583b19d0fa9b082d5b8e36b31f517d512572b"
    sha256 cellar: :any, arm64_linux:       "87855c40ff71978c66a39cfcb19d407a8fa83a302d42a57eb2941728e9922009"
    sha256 cellar: :any, x86_64_linux:      "cbfa3337697c4585b2f0cbe679af7802046c36cd9162f519af89b33c3d52b4e0"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "make", "install", "PREFIX=#{prefix}"
    # Prevent dependents from hardcoding Cellar paths.
    inreplace lib/"pkgconfig/liblz4.pc", prefix, opt_prefix

    # We use CMake for package configuration files. These are currently needed to build `tiledb`.
    # The Makefile is used for everything else as official build system and installs multi-threaded CLI.
    ENV["DESTDIR"] = buildpath
    system "cmake", "-S", "build/cmake", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_STATIC_LIBS=ON", # for LZ4::lz4_static target
                    "-DLZ4_BUILD_CLI=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build" # needed to run `--install` which rewrites build path in .cmake file
    system "cmake", "--install", "build"
    lib.install File.join(buildpath, lib, "cmake")
  end

  test do
    input = "testing compression and decompression"
    compressed = pipe_output(bin/"lz4", input)
    refute_empty compressed
    decompressed = pipe_output("#{bin}/lz4 -d", compressed)
    assert_equal decompressed, input

    # Make sure lz4 executable is built multi-threaded
    assert_match "multithread", shell_output("#{bin}/lz4 -V")
  end
end
