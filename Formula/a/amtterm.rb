class Amtterm < Formula
  desc "Serial-over-LAN (sol) client for Intel AMT"
  homepage "https://www.kraxel.org/blog/linux/amtterm/"
  url "https://gitlab.com/kraxel/amtterm/-/archive/amtterm-1.8-1/amtterm-amtterm-1.8-1.tar.bz2"
  sha256 "d2da2effaa4e8d499a81c9185a3ccde48abffcafaac0d991218dd8974d055719"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/kraxel/amtterm.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "33934a9d2469315d7e292462ed352c552a01ef9717c98ed502b693fc496731f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "18584332d73c1ec0c92903282b8363ec3d459b2bfacd19748f69607652cc40c8"
  end

  depends_on "glib"
  depends_on "gnutls"
  depends_on "meson"
  depends_on "pkgconf"

  on_linux do
    depends_on "gtk+3"
    depends_on "pango"
    depends_on "vte3"
  end

  resource "SOAP::Lite" do
    url "https://cpan.metacpan.org/authors/id/P/PH/PHRED/SOAP-Lite-1.27.tar.gz"
    sha256 "e359106bab1a45a16044a4c2f8049fad034e5ded1517990bc9b5f8d86dddd301"

    livecheck do
      url :url
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("SOAP::Lite").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    assert_match "Connection refused", shell_output("#{bin}/amtterm -u brew -p brew 127.0.0.1 2>&1", 1)

    assert_match version.major_minor.to_s, shell_output("#{bin}/amtterm -v 2>&1", 1)
  end
end
