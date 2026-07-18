class Libyojimbo < Formula
  desc "Secure client/server network protocol library for multiplayer games"
  homepage "https://github.com/mas-bandwidth/yojimbo"
  url "https://github.com/mas-bandwidth/yojimbo/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "b1266d2a08f147518ee6379af81a1477c39b2650c32c94f1125c4178f8ea6cdc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dbc2f1935619c52784b0ced227711b77bf8943fcf31c29719ddc796e5864f7b8"
    sha256 cellar: :any, arm64_sequoia: "6d52f5d44be0ccfe7e4421f42aa0e73fec1b4d4cd8635bdb096afdd6aa85f75d"
    sha256 cellar: :any, arm64_sonoma:  "ce751cbdeaaaf37f99c49f92c2adef98725aa365539761445e33671de58c34e1"
    sha256 cellar: :any, sonoma:        "52b1f62480ad94d64da600866e82ab010a0a3671f650d415034db2e6c7c23fb4"
    sha256 cellar: :any, arm64_linux:   "f610ea2b77278c60f50094958841b7ae1919e3091d5a8224c835931d1686acec"
    sha256 cellar: :any, x86_64_linux:  "939c020908bf1fd6908c3cb83a0f4b88f66fb0a4d870229f3efeb917f637d474"
  end

  depends_on "cmake" => :build
  depends_on "libsodium"
  depends_on "netcode"
  depends_on "reliable"
  depends_on "serialize"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DYOJIMBO_SYSTEM_DEPS=ON",
                    "-DYOJIMBO_BUILD_TESTS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <yojimbo.h>

      int main() {
        if (!InitializeYojimbo()) {
          return 1;
        }
        ShutdownYojimbo();
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lyojimbo", "-o", "test"
    system "./test"
  end
end
