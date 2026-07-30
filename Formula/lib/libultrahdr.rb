class Libultrahdr < Formula
  desc "Reference codec for the Ultra HDR format"
  homepage "https://developer.android.com/media/platform/hdr-image-format"
  url "https://github.com/google/libultrahdr/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "2516ea9cb69a0efd42959fad56de760fcb898a4944231f20789f9c5387ca9c81"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4864316dc44b74ba68fb8747d6b9128c3f6236510fc7c68b293b90d8e8ffd085"
    sha256 cellar: :any, arm64_sequoia: "b07bf479d2ae5dde596991210784e1faa48c8b558e264baa3731db075add8e94"
    sha256 cellar: :any, arm64_sonoma:  "2ca0693ce748670dab8839557558d6af6e87f104b924d73b76de54deb22c0e7a"
    sha256 cellar: :any, sonoma:        "5a17e8ae337e92355e971732733b9d6b3dc64adcb69bfd7b25203a1a1bdadf1c"
    sha256 cellar: :any, arm64_linux:   "cd6216ddfd0bb416e3df4772118da01f0edf7a579ab4bb07267b0eb881254019"
    sha256 cellar: :any, x86_64_linux:  "8f814acaebc240da683fced06c4f3a1b1f14d6390a23a3c449c6f2b9e40ec822"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "jpeg-turbo"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("pkg-config --modversion libuhdr")

    (testpath/"test.cpp").write <<~CPP
      #include <ultrahdr_api.h>
      #include <iostream>

      int main() {
        uhdr_codec_private_t* encoder = uhdr_create_encoder();
        if (encoder == nullptr) return 1;
        uhdr_release_encoder(encoder);

        std::cout << "encoder ok" << std::endl;
        return 0;
      }
    CPP

    pkg_config_cflags = shell_output("pkg-config --cflags --libs libuhdr").chomp.split
    system ENV.cxx, "test.cpp", "-o", "test", *pkg_config_cflags
    assert_match "encoder ok", shell_output("./test")
  end
end
