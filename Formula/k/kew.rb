class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v4.1.2.tar.gz"
  sha256 "b7dd255a84f25e8498c8a74f58ca16c0bb3b63f13df668297a93b93e70e531bf"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "b4086db09642dd24788736d4088489a6dce9ad8498aad7e8b363c334e26ca4c9"
    sha256 arm64_sequoia: "e92c7cddbc3836807281fe69649fa3fce7a8829a444e8757a8416de61be88dc7"
    sha256 arm64_sonoma:  "d968cad38dfcc9ebc8812f71a6e40e8dba5aed72b7de287d9574f59233fc37e3"
    sha256 sonoma:        "67ab9dab1f030eb1f278cedc15d4da8030f17edbe1610e5e79f3735e7ddfd0af"
    sha256 arm64_linux:   "6fb176f5ba9069c8a79310f480a32a8ec1e259a733b5e72dd4f45f8c90a8b418"
    sha256 x86_64_linux:  "424e6f9efad23a4467ca2a02ada8da58c946ab725b4720ef48994bed687e7ea2"
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
