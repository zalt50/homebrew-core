class Libzim < Formula
  desc "Reference implementation of the ZIM specification"
  homepage "https://github.com/openzim/libzim"
  url "https://github.com/openzim/libzim/archive/refs/tags/9.4.0.tar.gz"
  sha256 "000d6e413963754c0e28327fbdd0a04afd05ea2a728f6438ef96795a2aa3edb8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4e89d062e9b266ef32c000632519ecb99f256b701005966f399246f21a8b9575"
    sha256 cellar: :any, arm64_sequoia: "b4ceecbeedcfc12b93d6f09afd9108509970317095e61792c171908037dfebd7"
    sha256 cellar: :any, arm64_sonoma:  "faebeb4b051a2de69ce34863390dbb6c623ea2f01d0ddc7265e9b73cab5aa917"
    sha256 cellar: :any, arm64_ventura: "0a36f78d2ec284ba491c030e071a9a5875106dac327bd6e060f479410b6c9331"
    sha256 cellar: :any, sonoma:        "c68a4e4aeb4d87ac9faec8349222751f49a4e570c15d5b1c05e93d2ca5cc57a7"
    sha256 cellar: :any, ventura:       "d342df82217c3d5d6e160bd5b5c6eb1301854bfeb7d2691bb250c04e3a634389"
    sha256               arm64_linux:   "5c4f15314c93fa0ab0f858bae329925eb9fabc5eeb75b390b34100f91208d6ee"
    sha256               x86_64_linux:  "8e90267f0cbdcda4336951766f6bce92b4b694031c98b19597ee146546bf9781"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "icu4c@77"
  depends_on "xapian"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "python" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <zim/version.h>
      int main(void) {
        zim::printVersions(); // first line should print "libzim <version>"
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzim", "-o", "test", "-std=c++11"
    assert_match "libzim #{version}", shell_output("./test")
  end
end
