class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v4.1.4.tar.gz"
  sha256 "af6f6dd5e9a45dbc842b405db6365d83a209c4a24c7fb7e111b5e5842cc3112b"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "deca162a89c7b4c4bbf143ed178b3d4ec48bc018cbb5153aad0e4e0eb2f20af6"
    sha256 arm64_sequoia: "5291efc81eca8ace43e315dd25028b6c959637c699aa95da853590be287e7214"
    sha256 arm64_sonoma:  "1d5da1298c03489a7387352c217176570d2906af7abc6fa45d3d9b61cdf620f5"
    sha256 sonoma:        "a596865e5972cf989179ee87974a70021aa30e3b4023b759ae6a01b1808bb716"
    sha256 arm64_linux:   "dc0eb342b7c85228d5f67a0302b2d1e193ee8afb35cb1933faf14a55f5c692de"
    sha256 x86_64_linux:  "8bf701a990b24ecd4a49f1a23287c9a344a9eee63b665749265bf58f799eaa7a"
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
