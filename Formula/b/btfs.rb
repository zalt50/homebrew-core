class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/refs/tags/v3.1.tar.gz"
  sha256 "c363f04149f97baf1c5e10ac90677b8309724f2042ab045a45041cfb7b44649b"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/johang/btfs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "cb3c4a3351015895e992b3c059b012aa24410edfa4795decafdbe7a850b9201c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "de0d62491fcf2a7793531a3b1e3900f10cca457b2a2f67d04f19588f9f1c0b62"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "libfuse"
  depends_on "libtorrent-rasterbar"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"

  # Build against libtorrent-rasterbar 2.1 (ABI 2)
  patch do
    url "https://github.com/johang/btfs/commit/9502625df2d1c0a7e70da2e75de81078de95318b.patch?full_index=1"
    sha256 "7f5c6974d4902b7cda3876e22e24c44a0a9ac933b16ff4b97fdbd39adbbbe7f8"
    type :unofficial
    resolves "https://github.com/johang/btfs/pull/109"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"btfs", "--help"
  end
end
