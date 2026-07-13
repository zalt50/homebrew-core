class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "b1d05da2cb62c5ec533ebaec06460d7238481fd6e0e4fc585a0c3ece94db129d"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "25950c3b8bc2b50effd87d7b454bec46122249d5518be9743c2a4d282e390043"
    sha256 arm64_sequoia: "79d4943a0af7aa90d08772c416b1bd958096a062fc263712c53859584f830fbd"
    sha256 arm64_sonoma:  "687ecb769b74fc0c626c504f784788783e402d17b726496369a84c140a6afc51"
    sha256 sonoma:        "7b93f58ccb36d42ea8da034a3cb30f913e63bb4b10c2b701595cd8b815f562bd"
    sha256 arm64_linux:   "8004d0f568895526cb40fbaaed90327e1ddd3331d53008192ee8d5f46a90ad86"
    sha256 x86_64_linux:  "947c817cfd89098ead25e505388e8494a2a08bc57559c3523bcab11fd899e636"
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
