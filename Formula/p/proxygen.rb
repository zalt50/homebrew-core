class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2025.10.27.00/proxygen-v2025.10.27.00.tar.gz"
  sha256 "250f21c36464b8a0c4bab5825540cdb40a000e2902d4c2e19c1e1a20fcbab946"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "5db1e2c3515b4f37854189fe0ae3d595d1992c20800a575ab25331b96d7c532c"
    sha256                               arm64_sequoia: "540c6273f0dfd435805ff9e41c0f4e53f087fd0d76bd4a4c916c22150011f7c3"
    sha256                               arm64_sonoma:  "576e9f6342433c1bbfb08e9df7a195c669a5731a1f8a9c7f47408fb32d57e134"
    sha256 cellar: :any,                 sonoma:        "595a7053a211044b1b78527ee97a1787bcb626d0d3bd5f5fcca280f9cd9512ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d90c5e3a19b122532ecb9646fd20df307541fb7b898692f758ed720f493b1e0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "486545056b228708ce9cb0ffec2fa9fc35792b224c6786ccd24c5b77410c3cf5"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "c-ares"
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "mvfst"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"

  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  conflicts_with "hq", because: "both install `hq` binaries"

  # Fix name of `liblibhttperf2`.
  # https://github.com/facebook/proxygen/pull/574
  patch do
    url "https://github.com/facebook/proxygen/commit/415ed3320f3d110f1d8c6846ca0582a4db7d225a.patch?full_index=1"
    sha256 "4ea28c2f87732526afad0f2b2b66be330ad3d4fc18d0f20eb5e1242b557a6fcf"
  end

  def install
    args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    if OS.mac?
      args += [
        "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
        "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs",
      ]
    end

    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    port = free_port
    pid = spawn(bin/"proxygen_echo", "--http_port", port.to_s)
    sleep 30
    sleep 30 if OS.mac? && Hardware::CPU.intel?
    system "curl", "-v", "http://localhost:#{port}"
  ensure
    Process.kill "TERM", pid
  end
end
