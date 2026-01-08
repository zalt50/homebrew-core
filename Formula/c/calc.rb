class Calc < Formula
  desc "Arbitrary precision calculator"
  homepage "http://www.isthe.com/chongo/tech/comp/calc/"
  url "https://github.com/lcn2/calc/archive/refs/tags/v2.16.1.2.tar.gz"
  sha256 "cb5b0576c3d206ed55b6929cc3a1ebc5afedbfdc70d528274cbac8e650c56d77"
  license "LGPL-2.1-or-later"
  head "https://github.com/lcn2/calc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "3476fd8b2ef10984bb14c7a60596b595c18ff90e9445bd826631489637f00ed9"
    sha256 arm64_sequoia: "72e2c76e494897cb649f24cefc4e2a293d3ff44cd010d6895bfc6e9ba2acad86"
    sha256 arm64_sonoma:  "0da51b7df44d64903cd43cbf7bc87c61713b31974d70654570b544fad0d42635"
    sha256 sonoma:        "5eddfceeff502e80a897e69526d1f6b6e4c423095501271400526a0693dc0df0"
    sha256 arm64_linux:   "cee9a11ffd305ee3726064508b00ca0aa3a5c2d2d0d41e56e6a81093aed79d7d"
    sha256 x86_64_linux:  "9c3119480da11633e5339492ff692b919af35c204d1745db8788763e0c298435"
  end

  depends_on "readline"

  on_linux do
    depends_on "util-linux" # for `col`
  end

  def install
    ENV.deparallelize

    ENV["EXTRA_CFLAGS"] = ENV.cflags
    ENV["EXTRA_LDFLAGS"] = ENV.ldflags

    args = [
      "BINDIR=#{bin}",
      "LIBDIR=#{lib}",
      "MANDIR=#{man1}",
      "CALC_INCDIR=#{include}/calc",
      "CALC_SHAREDIR=#{pkgshare}",
      "USE_READLINE=-DUSE_READLINE",
      "READLINE_LIB=-L#{Formula["readline"].opt_lib} -lreadline",
      "READLINE_EXTRAS=-lhistory -lncurses",
    ]
    args << "INCDIR=#{MacOS.sdk_path}/usr/include" if OS.mac?
    system "make", "install", *args

    libexec.install "#{bin}/cscript"
  end

  test do
    assert_equal "11", shell_output("#{bin}/calc 0xA + 1").strip
  end
end
