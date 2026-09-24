class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-22.1.3/libupnp-22.1.3.tar.bz2"
  sha256 "9685ad35fe38e831c89eb6edf708c83c6d74c55484aefbf7d9e84f39ea61f938"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3afcc2489cdab42b850fcbe7a4c95cd64dec2bd807303e5c7b46ad6784f08799"
    sha256 cellar: :any, arm64_tahoe:       "8a28bdbad89e26c5b248d5a5f99e606e70b2414b18a6589cfc6d3f914f6e923d"
    sha256 cellar: :any, arm64_sequoia:     "e103af30fd315049d3b22b8a8597b8585e400f453eeedfa3380091562c437472"
    sha256 cellar: :any, arm64_linux:       "817f3edcb7f1635d22bb6411f34c4fbf02d288639ff2bce34559a49e0727edf9"
    sha256 cellar: :any, x86_64_linux:      "a244d596c5f24d17ad27d22b51cb910a828ef8cfc871ca77600430f01edc35f1"
  end

  depends_on "cmake" => :build

  allow_network_access! :test

  def install
    # https://github.com/llvm/llvm-project/issues/65557
    if OS.mac? && DevelopmentTools.clang_build_version < 1700
      inreplace "upnp/src/genlib/miniserver/miniserver.c", "switch (gMServState)",
                                                           "switch ((MiniServerState)gMServState)"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DUPNP_BUILD_SAMPLES=OFF",
                    "-DUPNP_ENABLE_TESTING=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <upnp.h>
      #include <upnpconfig.h>
      #include <stdio.h>
      int main(void) {
        printf("UPNP_VERSION_STRING = \\"%s\\"\\n", UPNP_VERSION_STRING);
        int rc = UpnpInit2(NULL, 0);
        if (rc == UPNP_E_SUCCESS) {
          printf("UPnP Initialized OK\\n");
          UpnpFinish();
        }
        return rc;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}/upnp", "-L#{lib}", "-lupnp"
    output = shell_output("./test")
    assert_match "UPNP_VERSION_STRING = \"#{version}\"", output
    assert_match "UPnP Initialized OK", output
  end
end
