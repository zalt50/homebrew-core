class Tklib < Formula
  desc "Standard Tk Library (tklib)"
  homepage "http://www.tcl.tk/software/tklib/"
  url "https://core.tcl-lang.org/tklib/raw/tklib-0.9.tar.bz2?name=17f1d6d5fdad54ee"
  version "0.9"
  sha256 "dcce6ad0270fad87afe3dd915fb1387f25728451de8a6d1ef6b8240180819c2a"
  license "TCL"

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
