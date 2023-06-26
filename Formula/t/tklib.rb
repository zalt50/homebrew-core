class Tklib < Formula
  desc "A collection of utility modules for Tk, and a companion to Tcllib"
  homepage "http://www.tcl.tk/software/tklib/"
  url "https://core.tcl-lang.org/tklib/attachdownload/tklib-0.7.tar.bz2?page=Downloads&file=tklib-0.7.tar.bz2"
  version "0.7"
  sha256 "5a1283a1056350c7cb89fba4af1e83ed2dbfc2e310c5303013faae0b563e5ece"
  license "TCL"

  depends_on "tcl-tk"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-tclsh=#{Formula["tcl-tk"].opt_bin}/tclsh"
    system "make", "install-libraries"
  end
end
