require "formula"

class Ebu < Formula
  url "http://green.ribbon.to/~ikazuhiro/dic/files/ebu-4.5-20220808.tar.gz"
  homepage "http://green.ribbon.to/~ikazuhiro/dic/ebu.html"
  sha256 "df72d09a937dcc91586eff5b9e4d18b9d5d80bc78dd74e541b052f3ebe92a2a5"
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
