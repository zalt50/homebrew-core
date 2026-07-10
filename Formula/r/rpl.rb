class Rpl < Formula
  desc "Text replacement utility"
  homepage "https://github.com/rrthomas/rpl"
  url "https://github.com/rrthomas/rpl/releases/download/v2.1.0/rpl-2.1.0.tar.gz"
  sha256 "478d3c4c0a3b8ce3b7a1f7c6e576adb4a6a6e9d898ef6673994aac6d61ca7988"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b9818e66d4be4d4459dc59bba02beca0044596cf508c26ba29f7cb98f4c0ab1e"
    sha256 cellar: :any,                 arm64_sequoia: "b628ab24e76ae6d47df7e7b409b745f62d1e068053adb8234b7bf6dc64ad7ff8"
    sha256 cellar: :any,                 arm64_sonoma:  "be9e98e87ce5b54a49d72f9c7028601daea83bab9491015f43a00d9c4c90846b"
    sha256 cellar: :any,                 sonoma:        "efd688e33dad7f7bc9de4319febb6ed07e836fd5ed8c2fe1c2ec4035c97ad852"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0049ccf0f0623607cbb7e5123b55b0699948e5a9691e222763b12450fc4cbb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1ea919345b90a09395c9a0f57441c3b0a917ef1f2e7f4b1af006e66e96bce24"
  end

  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "pcre2"
  depends_on "uchardet"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test").write "I like water."

    system bin/"rpl", "-v", "water", "beer", "test"
    assert_equal "I like beer.", (testpath/"test").read
  end
end
