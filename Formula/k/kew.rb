class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "6d4cdaf32ecf08d0776869e311e650f762f7fddba2afc1921134441b3f23afa6"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "a72f36e6caa58bb2ac5d9ebf4627eb519cf1017df360068f6c0bf0ebcd815cd2"
    sha256 arm64_sequoia: "bbe133cb8daa6054c436886a63a36e1dfd6d4284f3f04c0d8e52950792075d9c"
    sha256 arm64_sonoma:  "f3b30bda387ecf10d85a5fa3da714d74ff0621606ef0941a6c291d261016a5a0"
    sha256 sonoma:        "0cfd90978d8d3d6cf1e2b0efc53f15938810717c5c22662c152d3ac2b0852e53"
    sha256 arm64_linux:   "f339460fd565efdbc5b658c75e3ffd5b9e7e6ac5ee9a0d7702eb1c860bf808e2"
    sha256 x86_64_linux:  "c2096d157b2874f1a5a77d3d0af5cbe0aab5f870c3fb7f1ff7f1aafce458db41"
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
    depends_on "gettext"
  end

  on_linux do
    depends_on "libnotify"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
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
