class Libyojimbo < Formula
  desc "Secure client/server network protocol library for multiplayer games"
  homepage "https://github.com/mas-bandwidth/yojimbo"
  url "https://github.com/mas-bandwidth/yojimbo/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "07b471d01ed16adbd01fcf97e71508cfbda55f34aa20253cc6fc5844de763240"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f92e9d12841cd900e16ea04142d1aa67d55aebcff4caf597ced1d61918c92478"
    sha256 cellar: :any, arm64_sequoia: "0f9f05d19ce538f094d8aa23e84f82019eead98f37f7a187db64fa8d0ba48167"
    sha256 cellar: :any, arm64_sonoma:  "c3a59b34a3e77e213c5945109bc58c422d51f5d86d337651fdd2663e9edeacdf"
    sha256 cellar: :any, sonoma:        "c06fe65a9c1f3e3f1e73bc16c7035a9736208faa3e16cf15e4c8086e26caa38a"
    sha256 cellar: :any, arm64_linux:   "1ffde9b910c3ee3dfa26ead04ee0590500069c713d538cdd85c2e98d2595efe3"
    sha256 cellar: :any, x86_64_linux:  "b393c304b8f809feb6ae0ce6471e819383bfa4ca2f1da7eb012e00ab2de00e9c"
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
