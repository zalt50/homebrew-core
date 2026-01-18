class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/cmus/cmus.git", branch: "master"

  stable do
    url "https://github.com/cmus/cmus/archive/refs/tags/v2.12.0.tar.gz"
    sha256 "44b96cd5f84b0d84c33097c48454232d5e6a19cd33b9b6503ba9c13b6686bfc7"

    # Backport FFmpeg 8 support using Debian patches as recommended by upstream
    # https://github.com/cmus/cmus/issues/1459#issuecomment-3733435414
    # The same patches are used by Arch Linux.
    patch do
      url "https://deb.debian.org/debian/pool/main/c/cmus/cmus_2.12.0-2.debian.tar.xz"
      sha256 "e7b29301e3edd7446fa7bc4c4e89ea5a4580a13e183cc57a59974ca385ec9818"
      apply "patches/0003-ip-ffmpeg-more-precise-seeking.patch",
            "patches/0004-ip-ffmpeg-skip-samples-only-when-needed.patch",
            "patches/0005-ip-ffmpeg-remove-excessive-version-checks.patch",
            "patches/0006-ip-ffmpeg-major-refactor.patch",
            "patches/0007-Validate-sample-format-in-ip_open.patch",
            "patches/0008-ip-ffmpeg-flush-swresample-buffer-when-seeking.patch",
            "patches/0009-ip-ffmpeg-remember-swr_frame-s-capacity.patch",
            "patches/0010-ip-ffmpeg-reset-swr_frame_start-when-seeking.patch",
            "patches/0011-ip-ffmpeg-better-frame-skipping-logic.patch",
            "patches/0012-ip-ffmpeg-don-t-process-empty-frames.patch",
            "patches/0013-ip-ffmpeg-improve-readability.patch",
            "patches/0014-ip-ffmpeg-fix-building-for-ffmpeg-8.0.patch",
            "patches/0015-ip-ffmpeg-change-sample-format-conversions.patch"
    end
  end

  bottle do
    sha256 arm64_tahoe:   "ccb3ef033e545c2f1610612c73c28ee5b2d195829f8a061137ff6345ba7198ec"
    sha256 arm64_sequoia: "e09385ddb5a370d854f4608b76c5a263541547ac91b7cc4a6517e1f3099a19a3"
    sha256 arm64_sonoma:  "a9d12ff2708a54953541bc5ae8ccb1ef3fd24aeb3365dbc8834337076faebd72"
    sha256 arm64_ventura: "ae3c328349aeb668ccb369a9aa2a6147e6718aec702cffc145de37a0f3b82e0e"
    sha256 sonoma:        "f67433b09c4f9f4c52ac189f99277c1698d8869196bf992265784b18ab63c443"
    sha256 ventura:       "af29c51757aea6aaf9c7aab6758ec590e31f7f5e323a7c682f76496fb8e1599e"
    sha256 arm64_linux:   "6d9800c3e1c74383aa02badeb42de89294de79afacb0fdeb7e09770e40ef9b4b"
    sha256 x86_64_linux:  "6fa906d04b003647aec2093fa275eee0d2ca65d1601b6048b76dfa2016e0ba4e"
  end

  depends_on "pkgconf" => :build
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libao" # See https://github.com/cmus/cmus/issues/1130
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "mp4v2"
  depends_on "ncurses"
  depends_on "opusfile"

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
  end

  def install
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
    expected_plugins += if OS.mac?
      %w[coreaudio]
    else
      %w[alsa pulse]
    end

    expected_plugins.each do |plugin|
      assert_match plugin, plugins, "#{plugin} plugin not found!"
    end
  end
end
