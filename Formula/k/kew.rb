class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "73a2271e1fd2b9d9cade283c1be4d489f7b42e6152bb92ffcac23db71754fb02"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "3dd2e2945eae9ea928f2477b6ad3d11e9d9249a71bf8124a5e379133bfeeafd7"
    sha256 arm64_sequoia: "3832925603328387a5a975d6e78a5e1d19f541ac3d6e540a11cce74b16e79f8e"
    sha256 arm64_sonoma:  "2d52ededed0402004726c4620eb3d84e0915795cd12b95fdd0a7ae675dae5031"
    sha256 sonoma:        "d8e125e7bf56b39f8646a1849aed04af13d85688fdb3f66002241365d77b2fc3"
    sha256 arm64_linux:   "dedfbd72a1c0e310408d038cd7cdad278a87caadfb346a5596aa83fffbcc2fa9"
    sha256 x86_64_linux:  "040890cf2bdc230762d555ed20d16444b5c12ee2947d1d6182cf2ba78c35e0c3"
  end

  depends_on "pkgconf" => :build
  depends_on "chafa"
  depends_on "faad2"
  depends_on "fftw"
  depends_on "glib"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opus"
  depends_on "opusfile"
  depends_on "taglib"

  uses_from_macos "curl"

  on_macos do
    depends_on "gdk-pixbuf"
    depends_on "gettext"
  end

  on_linux do
    depends_on "libnotify"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "LANGDIRPREFIX=#{prefix}"
    man1.install "docs/kew.1"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"

    (testpath/".config/kew").mkpath
    (testpath/".config/kew/kewrc").write ""

    system bin/"kew", "path", testpath

    output = shell_output("#{bin}/kew song")
    assert_match "No Music found.\nPlease make sure the path is set correctly", output

    assert_match version.to_s, shell_output("#{bin}/kew --version")
  end
end
