class Gkrellm < Formula
  desc "Extensible GTK system monitoring application"
  homepage "https://billw2.github.io/gkrellm/gkrellm.html"
  url "https://gkrellm.srcbox.net/releases/gkrellm-2.5.0.tar.bz2"
  sha256 "68c75a03a06b935afa93d3331ca1c2d862c1d50c3e9df19d9a8d48970d766b55"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gkrellm.srcbox.net/releases/"
    regex(/href=.*?gkrellm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "bb265e1e37d9a767aebf25d0270dd479149af664e01751f0e8cbe90a7b70db2b"
    sha256 arm64_sequoia: "b1914ad89f4d2a98a27a583ff421a80facd22dda1ddb5214a3084d8d31af1b11"
    sha256 arm64_sonoma:  "291a90717a25bb95ef0c496bdec82d885587559c31009bd552eedaa3a25f583d"
    sha256 arm64_ventura: "f7de52218b179c4604afe3453fd8d23e2f43cb974b73db9ac8ddd638317fc185"
    sha256 sonoma:        "40c0010f6bb061498f99a49574e95f69e48d3208a4a45d4958ebbf8b40e55100"
    sha256 ventura:       "b8ccfe42efe43ed8059fb2cb003af40f5c1cfe707022a01034a775240334eb7a"
    sha256 arm64_linux:   "617d0cafc444ce08abee09d52a9ee733250deb08ff16b80ea4dfe2c00e6b6e01"
    sha256 x86_64_linux:  "866d5ec29d28c584d77357100e4f8909cf2524cefb6859670578695c4dcb6cfb"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+" # GTK3 issue: https://git.srcbox.net/gkrellm/gkrellm/issues/1
  depends_on "openssl@3"
  depends_on "pango"

  on_macos do
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "libice"
    depends_on "libsm"
    depends_on "libx11"
  end

  def install
    args = []
    args << "-Dx11=disabled" if OS.mac?
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    pid = spawn "#{bin}/gkrellmd --pidfile #{testpath}/test.pid"
    sleep 2

    begin
      assert_path_exists testpath/"test.pid"
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
