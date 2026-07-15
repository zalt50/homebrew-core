class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v4.2.3.tar.gz"
  sha256 "4679d519fa2414f48cdfdaef27a2ffa2bfd1d67a2a8ac50bbfc1fff3a4ee9b49"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "72ae65222a555f8056a52640db8b0d81cb53dd6fbadc3c2e7924f707d46276ca"
    sha256 arm64_sequoia: "f316db428205aa69bdf8b038a5eee790d38e6edb1889a33cbaadaf627dd16c6d"
    sha256 arm64_sonoma:  "ff9e0d912ae92ed43ad986d7946c46c570231331cd5b69fef0a95a4347d6ca5a"
    sha256 sonoma:        "c0a494d4f32ded317312c0ba93930bb66fd668541aa2d326bb2e28f06d8e1b36"
    sha256 arm64_linux:   "0956160e9bdb87f7159248e96913cf3ae8cf2c6b177b96bec91090c33b7aadbf"
    sha256 x86_64_linux:  "c40811f2ad3b267f458a49f041a2bca6d27f62527d405fed591f8acd2afd7c34"
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
