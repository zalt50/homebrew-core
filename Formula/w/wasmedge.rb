class Wasmedge < Formula
  desc "Lightweight, high-performance, and extensible WebAssembly runtime"
  homepage "https://WasmEdge.org/"
  url "https://github.com/WasmEdge/WasmEdge/releases/download/0.16.0/WasmEdge-0.16.0-src.tar.gz"
  sha256 "6a12152c1d7fd27e4f4fb6486c63e4c2f2663bb0c6be0edb287ef5796ed32610"
  license "Apache-2.0"
  head "https://github.com/WasmEdge/WasmEdge.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c6a8bc60386545e6a945f76fee81f095c33f57d1f2c75bca756a38158843a44"
    sha256 cellar: :any,                 arm64_sequoia: "6f7b13da240b4605b6f33e0b969b6ac3b3ce26c9ee02b3bacc83a77ecd192c7b"
    sha256 cellar: :any,                 arm64_sonoma:  "a20c30f91a0846db3de784348bcff62c807d56f74fdd492d2cda29bb53fc2412"
    sha256 cellar: :any,                 sonoma:        "2b6c66b23637ef0815e63954ff032734e7b44cf35d682045e8e4207569e13ddc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afd779ff4bd06efcca2d1b13a7321fb7f7148b580e7e5f8f201f39121c4926ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31b7e307f8938878a7db41931767ab52955739cc26315c3289de73eea692fcfc"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "lld"
  depends_on "llvm"
  depends_on "spdlog"

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
