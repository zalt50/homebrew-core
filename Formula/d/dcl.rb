require "formula"

class Dcl < Formula
  desc "GFD Dennou Library"
  homepage "http://gfd-dennou.org/index.html.en"
  url "https://www.gfd-dennou.org/library/dcl/dcl-7.4.5.tar.gz"
  sha256 "9af631f25046f6d82a6b869423840438d3e0b7f7bbaaa6bf3cf2f73b3d32e1f4"
  license "BSD-2-Clause"

  depends_on "gcc"
  depends_on "gtk+3"
  depends_on "pkg-config"

  fails_with :clang do
    build 1300
    cause "Could not compile conftest.c"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
