class Libdvdread < Formula
  desc "C library for reading DVD-video images"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdread/7.0.1/libdvdread-7.0.1.tar.xz"
  sha256 "2e3e04a305c15c3963aa03ae1b9a83c1d239880003fcf3dde986d3943355d407"
  license "GPL-2.0-or-later"
  head "https://code.videolan.org/videolan/libdvdread.git", branch: "master"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libdvdread/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "3bf9b853635ca319646c757110872d67d4125abb66e5e4d092068527342fa586"
    sha256 cellar: :any,                 arm64_sequoia:  "6aaf06a46650503ddadff95be7584a8fc86ee6e2d3c357475d26566cfda2b10c"
    sha256 cellar: :any,                 arm64_sonoma:   "6d2583d6d35a5b71d45cfbfc63e3e76dd9757c85973752b1583c4af9502d723c"
    sha256 cellar: :any,                 arm64_ventura:  "221b4cb3ad771cc650454a1624a89348973c3ef5bedc5f526b77e4bbb281b938"
    sha256 cellar: :any,                 arm64_monterey: "7c258b5c5be30d3ee53dacd0b137d7faadb5e21e06e5cf98859e7728e91cf303"
    sha256 cellar: :any,                 arm64_big_sur:  "e8642520b4bc06ac122e5c7e3affa0c80ed79678b09d220c1973e042aa11d30f"
    sha256 cellar: :any,                 sonoma:         "b1fa4f93b744c0b212e021aa63fa59f901e40b3ce029c11ea68f1e727698e1ea"
    sha256 cellar: :any,                 ventura:        "dbf236d4d32bb5e6d4180910f464225e5a09989d8fc542ec8bd5d3493a962308"
    sha256 cellar: :any,                 monterey:       "6ba400a8d928d2cd478969406000895023049c5a2257f11b6fab2791ff8b7105"
    sha256 cellar: :any,                 big_sur:        "cd57db884506fccb0b37b4cde83db05ba9cb15cddf1092f401918ae0972ac495"
    sha256 cellar: :any,                 catalina:       "5cd4a9df11e095e001d9d8a2a587f4701696de974b5527aea260afc9c5cc4f49"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "82a35d755bc296bd802e404f47d1636732025171d577e9959b5b09f97d40b4fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5805295785ab4ce6aeb1bdfeb7fe1aab4946ea9df2555f2016bbc540322f9c81"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test
  depends_on "libdvdcss"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <dvdread/version.h>
      #include <stdio.h>

      int main(int argc, char** argv) {
        printf("%s\\n", DVDREAD_VERSION_STRING);
        return 0;
      }
    C

    pkg_config_flags = shell_output("pkgconf --cflags --libs dvdread").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
