class Libdvdnav < Formula
  desc "DVD navigation library"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdnav/7.0.0/libdvdnav-7.0.0.tar.xz"
  sha256 "a2a18f5ad36d133c74bf9106b6445806fa253b09141a46392550394b647b221e"
  license "GPL-2.0-or-later"
  head "https://code.videolan.org/videolan/libdvdnav.git", branch: "master"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libdvdnav/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "96da091d8cd2f383ed296945d5022043df053962c612f7e1e85138069f106534"
    sha256 cellar: :any,                 arm64_sequoia:  "b29b26c47215e0956115db5aa20172efaa92d178877f7f2e526efa661282f481"
    sha256 cellar: :any,                 arm64_sonoma:   "77516e8cb99cad1e25fd119a6c573e0fb9c96b5ed7685f1222b9f76a5d1d1013"
    sha256 cellar: :any,                 arm64_ventura:  "77a874039ce80696ea655e95514dc26776a34f1c9675f583ebc0b9ae083be84c"
    sha256 cellar: :any,                 arm64_monterey: "efafd019d3a0cff8710e286c2fd7817865b1be5ff539c39639c71de9f61d9c50"
    sha256 cellar: :any,                 arm64_big_sur:  "e3ea0ddda7b96b799c2a67fd6687c25679001e2dc3893f200c70d4a599bc3996"
    sha256 cellar: :any,                 sonoma:         "1652846a6a793bc010056d0720931b73ae544fe5f378681b3223b9595b8b41be"
    sha256 cellar: :any,                 ventura:        "53d1dde0566dc12fe4e804d379d7b7cdfdc411dae8b290e866517c6f1023b796"
    sha256 cellar: :any,                 monterey:       "56d2c8450b882b776d5935a138d8031585366f59a740ea26db871d06c94d7d95"
    sha256 cellar: :any,                 big_sur:        "cabd25ecc0df8a3729e7196737e56041d8d6b9f369972d66de1ade19b4bfbafb"
    sha256 cellar: :any,                 catalina:       "ded7214f830c32676e5a64c2836b5498e44aeaa4967c5753a89c48af66edeaf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1a7a8631234c11e7d11e3ef82761671345883d42f2294382280bce8ddc7601a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0aadfc77f6807e5067f04391b0da4b6a0173c0219552f90ee300e17bd5679d9"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libdvdread"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <dvdnav/version.h>
      #include <stdio.h>

      int main(int argc, char** argv) {
        printf("%s\\n", DVDNAV_VERSION_STRING);
        return 0;
      }
    C

    pkg_config_flags = shell_output("pkgconf --cflags --libs dvdnav").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
