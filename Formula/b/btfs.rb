class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/refs/tags/v3.2.tar.gz"
  sha256 "f41094e7433b36708bd79e4e2a9431731cbd203c0615aa28a1ac71058126dba1"
  license "GPL-3.0-only"
  head "https://github.com/johang/btfs.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_linux:  "1901044b62b283b923ca81c7f4bc266d66792c954a0cd8ca2d193d2f66199dd3"
    sha256 cellar: :any, x86_64_linux: "d07682bfcd27d7ba108267d7ab8a4bcba3580a506d0beb7a424274b242d491c3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "libfuse"
  depends_on "libtorrent-rasterbar"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"btfs", "--help"
  end
end
