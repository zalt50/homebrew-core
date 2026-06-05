class Avisynthplus < Formula
  desc "Improved version of the AviSynth frameserver"
  homepage "https://avs-plus.net"
  url "https://github.com/AviSynth/AviSynthPlus/archive/refs/tags/v3.7.5.tar.gz"
  sha256 "2533fafe5b5a8eb9f14d84d89541252a5efd0839ef62b8ae98f40b9f34b3f3d5"
  license "GPL-2.0-or-later"
  head "https://github.com/AviSynth/AviSynthPlus.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "devil" # for ImageSeq plugin.
  depends_on "sound-touch" # for TimeStretch plugin.

  on_linux do
    depends_on "hicolor-icon-theme"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <avisynth/avisynth.h>
      int main() {
        IScriptEnvironment* env = CreateScriptEnvironment(AVISYNTH_INTERFACE_VERSION);
        if (!env) return 1;

        env->DeleteScriptEnvironment();
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lavisynth"
    system "./test"
  end
end
