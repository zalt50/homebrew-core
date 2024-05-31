require "formula"

class Eblook < Formula
  url "http://green.ribbon.to/~ikazuhiro/lookup/files/eblook-1.6.1+media-20220426.tar.gz"
  homepage "http://green.ribbon.to/~ikazuhiro/lookup/lookup.html#EBLOOK"
  sha256 "0a26ac65567bc2854245289040f5689952ba23925dff9faeae62471c475c3569"
  license "GPL-2.0"
  version "1.6.1+media-20220426"

  depends_on "zalt50/core/ebu"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}",
                          "--without-eb-conf",
                          "--with-ebu-conf=#{etc}/ebu.conf"
    system "make install"
  end

  test do
    system "#{bin}/eblook", "--version"
  end
end
