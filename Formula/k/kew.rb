class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v4.2.5.tar.gz"
  sha256 "a17f4acd54c78511bb14fc4e02aaaafc351f640388c3d29254f4397edfdc16a1"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "b7a773000a04779fc5a8a3170b8239c6477965d5b094b7a501ebfa4e0bf3d5b1"
    sha256 arm64_sequoia: "4711a58fe43d6cf050899674027ce69e7cf8cc6de0c544fe3bf4e2283d99a563"
    sha256 arm64_sonoma:  "fa3674d98ca1c19086901736dd8562dd04e784610e4a90479adfebde87d71089"
    sha256 sonoma:        "0c43bd47f374016e20d110bc10d70f03f86d68e33ae6244fe4a50aa677d570e6"
    sha256 arm64_linux:   "2435358295479fe3871e93f0a7924a07e64b1f11f6c4744d16b06b6709166783"
    sha256 x86_64_linux:  "bb18d3f7d7a60a1f5299caa9c791e13a3da58c615991b242b6c80504d3b9d9ff"
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
