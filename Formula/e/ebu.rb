require "formula"

class Ebu < Formula
  url "http://green.ribbon.to/~ikazuhiro/dic/files/ebu-4.5-20220808.tar.gz"
  homepage "http://green.ribbon.to/~ikazuhiro/dic/ebu.html"
  sha256 "374e90f8738d0ffc7a1e2f3d1c2be70626135f89aeb0656bc7ab0a0eb66f5b89"
  license "BSD-3-Clause"
  version "4.5-20220808"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/ebuunzip", "--version"
  end
end
