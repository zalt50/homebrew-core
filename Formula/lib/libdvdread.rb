class Libdvdread < Formula
  desc "C library for reading DVD-video images"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdread/7.1.0/libdvdread-7.1.0.tar.xz"
  sha256 "0bab58b7fbbc22a4a8497435eda7c88c20ba5b575da22d1ee2c6842c16dae8ea"
  license "GPL-2.0-or-later"
  compatibility_version 1
  head "https://code.videolan.org/videolan/libdvdread.git", branch: "master"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libdvdread/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "1af80a56982f63473b2f068b6580cdbadea4c6565743a3f12a21902cbaf0d3dc"
    sha256 cellar: :any, arm64_sequoia: "9dfed914bad377bc19f96a1d1f03da797e81264391d4726b1893d3dee8e9c37c"
    sha256 cellar: :any, arm64_sonoma:  "a728eb5b019155bba93815034450f9f92e3319c15928a3708bd0b019940b699c"
    sha256 cellar: :any, sonoma:        "a56d7091a092d522823af1ade8f88bdd42c82f6104ba4252f4910c23638dbc3d"
    sha256               arm64_linux:   "a3271813c01cd5ba6329facdb2dc46f08d36a4c5afc206ae2fa5148ab9bb4233"
    sha256               x86_64_linux:  "3a828260d4443afa4c8a45b0a5ca3ce6bf003aee19909ec15d3684ed07b477dc"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
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
