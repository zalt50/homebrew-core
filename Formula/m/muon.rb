class Muon < Formula
  desc "Meson-compatible build system"
  homepage "https://muon.build"
  url "https://git.sr.ht/~lattis/muon/archive/0.7.0.tar.gz"
  sha256 "e7095741dc11338f5ed8e0aa02e993fc34df4295dad4296127bbb212bcf56e07"
  license "GPL-3.0-only"
  head "https://git.sr.ht/~lattis/muon", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "faab696040afd48d798245a94ea7a7dd8c014095a4173a4f91409e0649963eef"
    sha256 cellar: :any, arm64_tahoe:       "9bce6352af4d970a3b54f28a21601f5348a15a564d5e7533c2ee1fcac824573a"
    sha256 cellar: :any, arm64_sequoia:     "19129ebd38d6de26680e50a50aa89535456ac8b1b2fa45c99114849541292f2b"
    sha256 cellar: :any, arm64_sonoma:      "a6c7d5852da7a68dafb411b8c8e87e651151eb1bfbd35cefd4ce0a3750a0d13c"
    sha256 cellar: :any, sonoma:            "38d553b4ccd78ae8c5f46aef7a36f4262771b3e4a7642a57bdc72ca8402714e7"
    sha256               arm64_linux:       "40dce766e246b6c82ebd7980f023919acf99e33d84a55fde0c2fe1597f0e8570"
    sha256               x86_64_linux:      "ca66c70c23f9b9f31826d84de3bd608e7c6ee576695f9249b35ad3b33a189464"
  end

  depends_on "meson" => :build
  depends_on "scdoc" => :build
  depends_on "libarchive"
  depends_on "ninja"
  depends_on "pkgconf"

  uses_from_macos "curl"

  deny_network_access!

  def install
    args = %w[
      -Dman-pages=enabled
      -Dmeson-docs=disabled
      -Dmeson-tests=disabled
      -Dlibarchive=enabled
      -Dlibcurl=enabled
      -Dlibpkgconf=enabled
      -Dsamurai=disabled
      -Dtracy=disabled
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"helloworld.c").write <<~C
      #include <stdio.h>
      int main() {
        puts("hi");
        return 0;
      }
    C
    (testpath/"meson.build").write <<~MESON
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    MESON

    system bin/"muon", "setup", "build"
    assert_path_exists testpath/"build/build.ninja"

    system "ninja", "-C", "build", "--verbose"
    assert_equal "hi", shell_output("build/hello").chomp
  end
end
