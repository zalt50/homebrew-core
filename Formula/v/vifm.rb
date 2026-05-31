class Vifm < Formula
  desc "Ncurses-based file manager with vi-like keybindings"
  homepage "https://vifm.info/"
  url "https://github.com/vifm/vifm/releases/download/v0.14.4/vifm-0.14.4.tar.bz2"
  sha256 "40bc32ec10d829ada3d0297d33cd4f302c520bb431287d544fc0a05ae45fdb1b"
  license "GPL-2.0-or-later"
  head "https://github.com/vifm/vifm.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "fef99972b61b5f0ca5f6f5214dc9fae1d90508558fb0775e0bcdc7786dba2587"
    sha256 arm64_sequoia: "803d2f505403b4c23e678df422bbaf2f2aa1dd6e568274b32a4eb50f0a34ee98"
    sha256 arm64_sonoma:  "6508066db55cdff5af7884ad5ba6455a636434c4f637397981304d034651baa5"
    sha256 arm64_ventura: "3c628a1a387e199df5b32697e171202ac2f9d3cda71d3f62f932e8366b60e50d"
    sha256 sonoma:        "38c54361f27f82b26c461669e3bd56211d79fa229e9644214492591e5b4780b1"
    sha256 ventura:       "f36622bdf6b5e6cde98dee0a65b5c0b8b963bf6cbc7dd0e379fb4509aa0de358"
    sha256 arm64_linux:   "22f6ba59fbe1dc0925d355e21a4ac014f31830cd34c9405958aea1f90620e674"
    sha256 x86_64_linux:  "a1023542a6fdad4e838d0c449365c52698690f23b901a2ddde744bdf79db0619"
  end

  depends_on "ncurses"

  uses_from_macos "mandoc" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-curses=#{Formula["ncurses"].opt_prefix}",
                          "--without-gtk",
                          "--without-libmagic",
                          "--without-X11"
    system "make"
    system "make", "check"

    ENV.deparallelize { system "make", "install" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vifm --version")
  end
end
