class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "7be478c476f0a9915cdefbf6aade825a40cd202a8ca6b5149399025d3c7fc09b"
  license "GPL-2.0-or-later"
  head "https://github.com/cmus/cmus.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "e8a9bd57f67c905a659ca77f16cdde838bb36abc86d74681eb0531d9ab096227"
    sha256 arm64_tahoe:       "210377c9fda621f2405c82368826b836f477a2b6c810074ade5827d838bf3dd3"
    sha256 arm64_sequoia:     "cfe58b83c5dcd733e8d0b30920ab783cb68518e6369fd7fa66f2a15f806fa72e"
    sha256 arm64_sonoma:      "f051ca658766a48c546040fc6fed6d76f2a5014174e2ac8dddd34b23cfa36a88"
    sha256 sonoma:            "e557635620a6cb4182d3ad7dd754b41ccfd41060183346e808236c2a4438626c"
    sha256 arm64_linux:       "27ad28ba4977fe3cba76ba21fca347507b66fd97e297761224da4bcb2cc73d9b"
    sha256 x86_64_linux:      "74ac30d857315bdd36ca022035ba04b2326486ead7c9ab44853536a48e807670"
  end

  depends_on "pkgconf" => :build
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libao" # See https://github.com/cmus/cmus/issues/1130
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "ncurses"
  depends_on "opusfile"

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  deny_network_access!

  def install
    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=765634#10
    # https://www.gnu.org/licenses/license-list.html#MPL
    # https://www.mozilla.org/en-US/MPL/1.1/FAQ/
    odie "mp4v2 is licensed under MPL-1.1 which is incompatible with GPL!" if deps.map(&:name).include?("mp4v2")

    args = [
      "prefix=#{prefix}",
      "mandir=#{man}",
      "CONFIG_WAVPACK=n",
      "CONFIG_MPC=n",
      "CONFIG_AO=y",
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    plugins = shell_output("#{bin}/cmus --plugins")
    expected_plugins = %w[
      aac
      cue
      ffmpeg
      flac
      mad
      mp4
      opus
      vorbis
      wav
      ao
    ]
    expected_plugins += OS.mac? ? %w[coreaudio] : %w[alsa pulse]

    expected_plugins.each do |plugin|
      assert_match plugin, plugins, "#{plugin} plugin not found!"
    end
  end
end
