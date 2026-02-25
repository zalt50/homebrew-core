class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://protobuf.dev/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v34.0/protobuf-34.0.tar.gz"
  sha256 "e540aae70d3b4f758846588768c9e39090fab880bc3233a1f42a8ab8d3781efd"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4bff0639995cb00420302c64dda3ae9eed6de24632fb158100e3ea05827ed844"
    sha256 cellar: :any, arm64_sequoia: "67aa3f9858e52ac658dc3c27091a6be275bb618aa94b3fbcc0e52a8e2b486744"
    sha256 cellar: :any, arm64_sonoma:  "aa983aa28a537848aef4673b3d184f07ee970f9271cda474c31ab11be487756f"
    sha256 cellar: :any, sonoma:        "0c4ed6e9a1c0e917d9d29bb0e391123541b2e2e7f1cee8acff7324bbe9ae47e0"
    sha256               arm64_linux:   "9a71cdbdefb4ac6b2b7cdff448f48df64a8c2b4a41c274227c7e320e10bea0d4"
    sha256               x86_64_linux:  "38502c5697b730a7643bf04a72d01198ae494d114f11af1f0446595e9440b3a3"
  end

  depends_on "cmake" => :build
  depends_on "abseil"

  on_macos do
    # TODO: Try restoring tests on Linux in a future release. Currently they
    # fail to build as Clang causes an ABI difference in Abseil that impacts
    # a testcase. Also GCC 13 failed to compile UPB tests in Protobuf 34.0
    depends_on "googletest" => :build
  end

  on_linux do
    depends_on "llvm" => :build if DevelopmentTools.gcc_version < 13
    depends_on "zlib-ng-compat"
  end

  fails_with :gcc do
    version "12"
    cause "fails handling ABSL_ATTRIBUTE_WARN_UNUSED"
  end

  def install
    # TODO: Remove after moving CI to Ubuntu 24.04. Cannot use newer GCC as it
    # will increase minimum GLIBCXX in bottle resulting in a runtime dependency.
    ENV.llvm_clang if OS.linux? && deps.map(&:name).any?("llvm")

    # Keep `CMAKE_CXX_STANDARD` in sync with the same variable in `abseil.rb`.
    abseil_cxx_standard = 17
    cmake_args = %W[
      -DCMAKE_CXX_STANDARD=#{abseil_cxx_standard}
      -DBUILD_SHARED_LIBS=ON
      -Dprotobuf_BUILD_LIBPROTOC=ON
      -Dprotobuf_BUILD_SHARED_LIBS=ON
      -Dprotobuf_INSTALL_EXAMPLES=ON
      -Dprotobuf_BUILD_TESTS=#{OS.mac? ? "ON" : "OFF"}
      -Dprotobuf_FORCE_FETCH_DEPENDENCIES=OFF
      -Dprotobuf_LOCAL_DEPENDENCIES_ONLY=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "ctest", "--test-dir", "build", "--verbose"
    system "cmake", "--install", "build"

    (share/"vim/vimfiles/syntax").install "editors/proto.vim"
    elisp.install "editors/protobuf-mode.el"
  end

  test do
    (testpath/"test.proto").write <<~PROTO
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    PROTO
    system bin/"protoc", "test.proto", "--cpp_out=."
  end
end
