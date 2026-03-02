class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2026.03.02.00/proxygen-v2026.03.02.00.tar.gz"
  sha256 "9a6bfc54ad2adebd7dd2d1a9afc6c659601425a9abcbab0727fa22112b235106"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "c795501b553107f1119136850f2637d4a73766a1335cb027afe21753eeae8aca"
    sha256                               arm64_sequoia: "42756f17eadc76638812f064948122a4929fa439ebe3b2c88c1ee2857b7ee788"
    sha256                               arm64_sonoma:  "d923df709994fa94e8af6ffc042690f3cfe872ccc1fe237a7fcd5c10f104dc3c"
    sha256 cellar: :any,                 sonoma:        "af5664751e313c72bbfa6c91d53386acb2769551239cd18428a8cdf739ba6c3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fd50ecf74c1dfe45f735951779d4d5a7533ab58dbbe48a0b46dd21706c41e8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0e659f828f8cd2c4a1007dedd088e6d9cbc28eb1106f64ce7664be2b65d127a"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "hq", because: "both install `hq` binaries"

  def install
    # FIXME: shared libraries are currently broken. Unlikely to get much upstream
    # support given `BUILD_SHARED_LIBS` says: "This is generally discouraged".
    args = ["-DBUILD_SHARED_LIBS=OFF", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
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
