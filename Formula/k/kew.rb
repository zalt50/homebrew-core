class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v4.1.6.tar.gz"
  sha256 "d5fd38cfb70d1fe87853acbd6e4013fc60041a7218ce9d87d12fc9b5fe82a4ea"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "fbbc1d172432205165bae4ec6e1b03c182f531068dd984fbf16cfa2901b067e0"
    sha256 arm64_sequoia: "81908d59675c1885ecae319f408ca5245e44e3300bd89790077bd7360ebaef73"
    sha256 arm64_sonoma:  "23d62d2dba634cec800cffa24d5f1cef1c751d4fb25bc3bde0bd30a875c693e1"
    sha256 sonoma:        "f3d66d3461852f9cc28268072bb0774973f96f07ccc0af27ffaa54258ccf27fc"
    sha256 arm64_linux:   "522c750bee85389d3239882abd74fd9b7a26e2f151992224aca0851b9c51f841"
    sha256 x86_64_linux:  "c3203a6862b8c0807108858814208383aa0beed14e9c20e77d84e2fc2773a161"
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
