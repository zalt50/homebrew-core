class Libdrm < Formula
  desc "Library for accessing the direct rendering manager"
  homepage "https://dri.freedesktop.org"
  url "https://dri.freedesktop.org/libdrm/libdrm-2.4.131.tar.xz"
  sha256 "45ba9983b51c896406a3d654de81d313b953b76e6391e2797073d543c5f617d5"
  license "MIT"

  livecheck do
    url "https://dri.freedesktop.org/libdrm/"
    regex(/href=.*?libdrm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "6e227e9ab3c0e7ec24949c2d20582ffe3bde9b5803f4c24e716df0b2bb8673de"
    sha256 x86_64_linux: "d5eeea0917331c5aadcdfda615dc8d13cc9ceaf6a6909831462c085a446b135a"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libpciaccess"
  depends_on :linux

  def install
    system "meson", "setup", "build", "-Dcairo-tests=disabled", "-Dvalgrind=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libdrm/drm.h>
      int main(int argc, char* argv[]) {
        struct drm_gem_open open;
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ldrm"
  end
end
