class Adplay < Formula
  desc "Command-line player for OPL2 music"
  homepage "https://adplug.github.io"
  url "https://github.com/adplug/adplay-unix/releases/download/v1.9/adplay-1.9.tar.bz2"
  sha256 "949b2618092a3aae5c278a98dfa3231130ef35a791b3afcaa0ebe45443ce82c8"
  license "GPL-2.0-or-later"

  head do
    url "https://github.com/adplug/adplay-unix.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "adplug"
  depends_on "libbinio"
  depends_on "sdl2"

  def install
    system "autoreconf", "-ivf" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules",
                          # SDL output works better than libao
                          "--disable-output-ao"
    system "make", "install"
  end

  test do
    resource "test_file" do
      url "https://github.com/adplug/adplug/raw/b5fe1a77a521d8072a95bd5a63450a55365505e9/test/testmus/TheAlibi.d00"
      sha256 "070bcb87f935d38e8561cb72228af4067c8f4f02a51d84437208d9f830055e2e"
    end

    assert_includes(shell_output("#{bin}/adplay --version"), "AdPlay/UNIX")

    resource("test_file").stage do
      output = shell_output("#{bin}/adplay TheAlibi.d00 --output=disk --device=TheAlibi.wav 2>&1")
      assert_match "EdLib packed (version 1)", output

      output = shell_output("/usr/bin/file TheAlibi.wav")
      assert_match "TheAlibi.wav: RIFF (little-endian) data, WAVE audio", output
    end
  end
end
