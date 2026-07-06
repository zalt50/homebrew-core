class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  url "https://github.com/WasmEdge/WasmEdge/releases/download/0.17.1/WasmEdge-0.17.1-src.tar.gz"
  sha256 "c8881a8c43407fc424ccd8586594a79068305b31c76aad0025efea9339be18e0"
  license "Apache-2.0"
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "615c0eef948c3bbf105c00276b1c50665f7ed9f757cf33883aa0445dce5a87fa"
    sha256 cellar: :any,                 arm64_sequoia: "2fe9bb85bb23325a7a69a37cd776634ec515eb97974adaa88d37be695ea2d8b0"
    sha256 cellar: :any,                 arm64_sonoma:  "162b6429735bf72c0213cf86eb7f2a7f351656b58c2c643b07a772f36c9d139b"
    sha256 cellar: :any,                 sonoma:        "a560be9e7d341e57684c7528ccde414b31ed568ff7dca1c17331362f027459d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc04f608509ed16364241d67303c654b1dcd0e7b3a5221e6013dae110ce58165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba4935916021264e93d4e33a58fcb884fa505bd2e72de8731dc18e75a483e904"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "lld"
  depends_on "llvm"
  depends_on "spdlog"

  # fmt 12.2 dropped operator~ on uint128_fallback; upstream fix not in 0.17.1.
  patch do
    url "https://github.com/WasmEdge/WasmEdge/commit/41a01b6b4f40defbac0dd551663c542cdcf9ae76.patch?full_index=1"
    sha256 "55657c3a628a406b655ba224019f0121f2489140dca128c3f8c623c019de84b1"
  end

  def install
    # Use CMAKE_BUILD_WITH_INSTALL_RPATH to keep versioned LLVM in RPATH on Linux
    args = ["-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"] if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # sum.wasm was taken from wasmer.rb
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmedge --reactor #{testpath/"sum.wasm"} sum 1 2")
  end
end
