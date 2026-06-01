class AlsaLib < Formula
  desc "Provides audio and MIDI functionality to the Linux operating system"
  homepage "https://www.alsa-project.org/"
  url "https://www.alsa-project.org/files/pub/lib/alsa-lib-1.2.16.tar.bz2"
  sha256 "122b1e3166d55fe19bcde656535d7a36f2ab10e66c72c6ad2f43f20ffded0a96"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  compatibility_version 1

  livecheck do
    url "https://www.alsa-project.org/files/pub/lib/"
    regex(/href=.*?alsa-lib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "423c02ab3ac3cafcd37c0cfe58042a64be9227a7a8680d299fe39428f38f077e"
    sha256 x86_64_linux: "54d16f2f52c4145966031382203596485bb9c9663a6398627ba65712febf24c9"
  end

  depends_on :linux

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    prefix.install "aserver/COPYING" => "COPYING-aserver"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <alsa/asoundlib.h>
      int main(void)
      {
          snd_ctl_card_info_t *info;
          snd_ctl_card_info_alloca(&info);
          return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lasound", "-o", "test"
    system "./test"
  end
end
