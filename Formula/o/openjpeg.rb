class Openjpeg < Formula
  desc "Library for JPEG-2000 image manipulation"
  homepage "https://www.openjpeg.org/"
  license "BSD-2-Clause"
  revision 1
  compatibility_version 1
  head "https://github.com/uclouvain/openjpeg.git", branch: "master"

  stable do
    url "https://github.com/uclouvain/openjpeg/archive/refs/tags/v2.5.4.tar.gz"
    sha256 "a695fbe19c0165f295a8531b1e4e855cd94d0875d2f88ec4b61080677e27188a"

    # TODO: Remove with the next release containing https://github.com/uclouvain/openjpeg/pull/1621.
    patch do
      url "https://github.com/uclouvain/openjpeg/commit/91d08b11a72764f6d199f32fa0c1b1abd4edc2ad.patch?full_index=1"
      sha256 "40648d63bfbb0f6c3a41cb9425ac48c396772c3527fff4b2979b07f42aaea6b8"
      type :backport
      resolves "OSV-2025-219"
    end

    # TODO: Remove with the next release containing https://github.com/uclouvain/openjpeg/pull/1628.
    patch do
      url "https://github.com/uclouvain/openjpeg/commit/839936aa33eb8899bbbd80fda02796bb65068951.patch?full_index=1"
      sha256 "d06af7a5e1681bb602e71bc1724718ff07f49aace9d841164658d72b1cfe7d5d"
      type :backport
      resolves "CVE-2026-6192"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "5458ec149fc1a3252192e4da2caea1af63f862cfcabec35526f9b7c386436444"
    sha256 cellar: :any,                 arm64_tahoe:       "e9becf9b440b08fd771dbaa75d4f5b06a49119f9ce163e6ad08f272f4f3b9c9d"
    sha256 cellar: :any,                 arm64_sequoia:     "8e3ac331458daccf876225a4236bad7d28689ea197c6bb7d2640ec47d78a510d"
    sha256 cellar: :any,                 arm64_sonoma:      "0eff9d5aae88cd27eaaedb4a4f56804ae14c4ed9df1c856846ff81ebc3dcb4c2"
    sha256 cellar: :any,                 sonoma:            "29b22e2c699765b32b3511f65bd87f6860d6bbf5f5f75e3b3ed5e268f6a547bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b570231cdd2898452318819d0dc97662145a463e0ba3162a113163e0f0066e2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ea1906cdeecd5edc87703596cc084dc305834b030af3847a8520f9eb8566eb1e"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DBUILD_DOC=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <openjpeg.h>

      int main () {
        opj_image_cmptparm_t cmptparm;
        const OPJ_COLOR_SPACE color_space = OPJ_CLRSPC_GRAY;

        opj_image_t *image;
        image = opj_image_create(1, &cmptparm, color_space);

        opj_image_destroy(image);
        return 0;
      }
    C
    system ENV.cc, "-I#{include.children.first}",
           testpath/"test.c", "-L#{lib}", "-lopenjp2", "-o", "test"
    system "./test"
  end
end
