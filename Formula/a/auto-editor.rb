class AutoEditor < Formula
  desc "Efficient media analysis and rendering"
  homepage "https://auto-editor.com"
  url "https://github.com/WyattBlue/auto-editor/archive/refs/tags/29.3.1.tar.gz"
  sha256 "6cfe85e08f034656b488c2455dc8556a45e585572d544193eeb9635de7230d1e"
  license "Unlicense"
  head "https://github.com/WyattBlue/auto-editor.git", branch: "master"

  depends_on "nim" => :build
  depends_on "pkgconf" => :build
  depends_on "dav1d"
  depends_on "ffmpeg"
  depends_on "lame"
  depends_on "libvpx"
  depends_on "opus"
  depends_on "svt-av1"
  depends_on "x264"
  depends_on "x265"

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    # Install Nim dependencies
    system "nimble", "install", "-y"

    # Build auto-editor
    system "nimble", "make"
    bin.install "auto-editor"
  end

  test do
    mp4in = testpath/"video.mp4"
    mp4out = testpath/"video_ALTERED.mp4"
    system "ffmpeg", "-filter_complex", "testsrc=rate=1:duration=5", mp4in
    system bin/"auto-editor", mp4in, "--edit", "none", "--no-open"
    assert_match(/Duration: 00:00:05\.00,.*Video: h264/m, shell_output("ffprobe -hide_banner #{mp4out} 2>&1"))
  end
end
