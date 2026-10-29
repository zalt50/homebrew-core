class Halide < Formula
  desc "Language for fast, portable data-parallel computation"
  homepage "https://halide-lang.org"
  url "https://github.com/halide/Halide/archive/refs/tags/v22.0.0.post3.tar.gz"
  version "22.0.0.post3"
  sha256 "de3e1a168de2a326eb9739e59fb2305fab58cb55085c8f11b2764adc0e1463d2"
  license "MIT"
  head "https://github.com/halide/Halide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:\.post\d+)?)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c586c3da977b977e10474a44056f97cc9ff5195dda4a6555c8e754b649d95780"
    sha256 cellar: :any, arm64_tahoe:       "85b61890e1fc5e57cd810402a3c37d0b25177b0d73c11c100abe799a032ba880"
    sha256 cellar: :any, arm64_sequoia:     "6e1e564e06aa5de6d592f6e7152fbdbec297c56890cff6535d5b885780f062bb"
    sha256 cellar: :any, arm64_linux:       "6f8526ee12cc6b07ddd4633b7ba26d348ddf7ba8f78b285e5551e17ad5194359"
    sha256 cellar: :any, x86_64_linux:      "cb1c77d4b844ac31c049e768a5372840f7c6987da19aec845f510bd3a91c36af"
  end

  depends_on "cmake" => :build
  depends_on "flatbuffers" => :build
  depends_on "nanobind" => :build
  depends_on "ninja" => :build
  depends_on "python@3.15" => [:build, :test]
  depends_on "lld"
  depends_on "llvm"
  depends_on "wabt" => :no_linkage

  deny_network_access!

  def install
    llvm = deps.map(&:name).find { |f| f.match?(/^llvm(@\d+(\.\d+)*)?$/) }
    site_packages = prefix/Language::Python.site_packages(python3)
    rpaths = [rpath, rpath(source: site_packages/"halide")]
    rpaths << formula_opt_lib(llvm).to_s if OS.linux?
    args = [
      "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}",
      "-DHalide_INSTALL_PYTHONDIR=#{site_packages}/halide",
      "-DHalide_LLVM_SHARED_LIBS=ON",
      "-DWITH_TESTS=OFF",
    ]
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp share/"doc/Halide/tutorial/lesson_01_basics.cpp", testpath
    system ENV.cxx, "-std=c++17", "lesson_01_basics.cpp", "-L#{lib}", "-lHalide", "-o", "test"
    assert_match "Success!", shell_output("./test")

    cp share/"doc/Halide_Python/tutorial-python/lesson_01_basics.py", testpath
    assert_match "Success!", shell_output("#{python3} lesson_01_basics.py")
  end
end
