class Libdvdcss < Formula
  desc "Access DVDs as block devices without the decryption"
  homepage "https://www.videolan.org/developers/libdvdcss.html"
  url "https://download.videolan.org/pub/videolan/libdvdcss/1.5.0/libdvdcss-1.5.0.tar.xz"
  sha256 "529463e4d1befef82e5c6e470db7661a2db0343e092a2fb0d6c037cab8a5c399"
  license "GPL-2.0-or-later"
  head "https://code.videolan.org/videolan/libdvdcss.git", branch: "master"

  livecheck do
    url "https://download.videolan.org/pub/libdvdcss/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "4f096a2de5e3d8409bfa2627dfff5bf3a14099f2384f2ec018ffaa4a6dcad182"
    sha256 cellar: :any,                 arm64_sequoia:  "eaa70f0ac608a56a596243c9bc63070dc358c7b31894f05cc3f3ac181035e8c2"
    sha256 cellar: :any,                 arm64_sonoma:   "a88500318685760e0425a099d0459f7be9f7505b89e69785af9d7ae183e40541"
    sha256 cellar: :any,                 arm64_ventura:  "d3a1da9ea4618f10137277bd109cc5d1c74ba3d82a2dc45f34370e1c389d8eea"
    sha256 cellar: :any,                 arm64_monterey: "c96a2adbc32a57e271a9a91d338571ab9b0a6524a95e3fe48270dd5c4a277b21"
    sha256 cellar: :any,                 arm64_big_sur:  "ef10943948da31c0015eb558758fea572963e381c13c203e79ee2169a826731a"
    sha256 cellar: :any,                 sonoma:         "cf8f30222c06a1c42dcf2e60bfc251b5fa778c9225a7523fe39ac56221926818"
    sha256 cellar: :any,                 ventura:        "8ebe4191446d0808caee8a4cf8796e16dbbf075195f51683fc55aaeb1b5c9a6e"
    sha256 cellar: :any,                 monterey:       "cde7ea8b386ddf37ae4ec4b0901ba70583e5bff84d6bea9624a7064fef11b6a8"
    sha256 cellar: :any,                 big_sur:        "6410e6fd033c0145e2d6d4676776cc4f4c20cf540836963d74a16788c842a7fd"
    sha256 cellar: :any,                 catalina:       "b5915184be3174c64f03a0895a9ee71dc8baac9dcd5bf5e904977890ccbba2ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "55bdf3ba9c347dd52ee1c5319b6a286c0e76cc8251c09d631f26e490a28d28d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b3979306018ca60bc17dc7547699ef716342c46c1e755ba15d53f6eb9ac92dd"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <dvdcss/version.h>
      #include <stdio.h>

      int main(int argc, char** argv) {
        printf("%s\\n", DVDCSS_VERSION_STRING);
        return 0;
      }
    C

    pkg_config_flags = shell_output("pkgconf --cflags --libs libdvdcss").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
