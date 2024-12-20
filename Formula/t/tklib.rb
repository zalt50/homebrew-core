class Tklib < Formula
  desc "A collection of utility modules for Tk, and a companion to Tcllib"
  homepage "http://www.tcl.tk/software/tklib/"
  url "https://core.tcl-lang.org/tklib/attachdownload/tklib-0.7.tar.bz2?page=Downloads&file=tklib-0.7.tar.bz2"
  version "0.7"
  sha256 "5a1283a1056350c7cb89fba4af1e83ed2dbfc2e310c5303013faae0b563e5ece"
  license "TCL"
  revision 1

  depends_on "tcl-tk@8"

  TCLSH_PATH = "#{Formula["tcl-tk@8"].opt_bin}/tclsh"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-tclsh=#{TCLSH_PATH}"
    system "make", "install-libraries"
  end

  test do
    assert_nil pipe_output(TCLSH_PATH, <<~TCL
      if {[catch {package require Plotchart} errorMsg]} {
        puts $errorMsg
      }
      exit
    TCL
    ).chomp!
  end
end
