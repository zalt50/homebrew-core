class Xdotool < Formula
  desc "Fake keyboard/mouse input and window management for X"
  homepage "https://www.semicomplete.com/projects/xdotool/"
  url "https://github.com/jordansissel/xdotool/archive/refs/tags/v4.20260303.1.tar.gz"
  sha256 "c1f971a384da588eb99ca0755fc4300316d49c1e612537e3f1de52215e104fa3"
  license "BSD-3-Clause"
  head "https://github.com/jordansissel/xdotool.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1e95a032ac6f60bf3c49d31c55fea5abf84ec2ac065a75922e2a0892be8468e7"
    sha256 cellar: :any,                 arm64_sequoia: "9e53f46e83125162422c96392380c9557b8a019e10bd51f742aaec18a61693c4"
    sha256 cellar: :any,                 arm64_sonoma:  "88878051080650c9faa9b0ab47c90ffc717c201eb106ad4b94ddc53341e3d45b"
    sha256 cellar: :any,                 sonoma:        "be7e226a05961c248eb48efbee734d0d3a8dedf952ac632d67fbbdee87a8a035"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e684b55a31331fcb19f43d7e3bac5a3185b2c374b421c8b5f196339def571a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "966f00d612ea8eac9d5e29b7842484dc70ebbba404a4557d02f4472a343974f3"
  end

  depends_on "pkgconf" => :build
  depends_on "libx11"
  depends_on "libxi"
  depends_on "libxinerama"
  depends_on "libxkbcommon"
  depends_on "libxtst"

  def install
    system "make", "PREFIX=#{prefix}", "INSTALLMAN=#{man}", "install"
  end

  def caveats
    <<~EOS
      You will probably want to enable XTEST in your X11 server now by running:
        defaults write org.x.X11 enable_test_extensions -boolean true

      For the source of this useful hint:
        https://stackoverflow.com/questions/1264210/does-mac-x11-have-the-xtest-extension
    EOS
  end

  test do
    system bin/"xdotool", "--version"
  end
end
