class Openkermit < Formula
  desc "Scriptable network and serial communication for UNIX and VMS"
  homepage "https://www.openkermit.org/"
  url "https://github.com/openkermit/ckermit/archive/refs/tags/v11.0.505.tar.gz"
  sha256 "c4cbbae6fd83e3aad318afdae72a993af9c5e73221e18d18f9b7a6937f3735c2"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  def install
    os = OS.mac? ? "macosx" : "linux"
    system "make", os, "KFLAGS=-DCK_NCURSES -I#{formula_opt_include("ncurses")}"

    man1.mkpath

    # The makefile adds /man to the end of manroot when running install
    # hence we pass share here, not man.  If we don't pass anything it
    # uses {prefix}/man
    system "make", "prefix=#{prefix}", "manroot=#{share}", "install"
  end

  test do
    system "#{bin}/kermit", "-C", "set host /network-type:pseudoterminal \"kermit -x\", get /bin/sh, bye, quit"
    assert_path_exists "sh"
  end
end
