require "formula"

class Eblook < Formula
  url "http://green.ribbon.to/~ikazuhiro/lookup/files/eblook-1.6.1+media-20200414.tar.gz"
  homepage "http://green.ribbon.to/~ikazuhiro/lookup/lookup.html#EBLOOK"
  sha256 "ebd5886176c2d52aea9077ef441af06b9181bda2ac4395def55ff305c288094e"
  license "GPL-2.0"
  version "1.6.1+media-20200414"

  depends_on "zalt50/core/ebu"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}",
                          "--without-eb-conf",
                          "--with-ebu-conf=#{etc}/ebu.conf"
    system "make install"
  end
end
