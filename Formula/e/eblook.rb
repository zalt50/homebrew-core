require "formula"

class Eblook < Formula
  url "http://green.ribbon.to/~ikazuhiro/lookup/files/eblook-1.6.1+media-20220426.tar.gz"
  homepage "http://green.ribbon.to/~ikazuhiro/lookup/lookup.html#EBLOOK"
  sha256 "e83c9521239ee046d37efa7b4cca356c1a3eac4e35a3153c90d6dd24c1cb0c0f"
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
