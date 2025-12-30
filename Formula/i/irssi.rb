class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.4.5/irssi-1.4.5.tar.xz"
  sha256 "72a951cb0ad622785a8962801f005a3a412736c7e7e3ce152f176287c52fe062"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "282823efaf7f56ecf1c24a585836da3bc9bbcaa44248c7b5483c0eceadc5f8ce"
    sha256 arm64_sequoia: "262cce3f4d6d06d0889360f32af77995a8a61b47ff89d4ce0859d370b679bb1e"
    sha256 arm64_sonoma:  "f9564eb23df20605176542ccf7ff19b09296397111ec182a659dee69ff3bd871"
    sha256 sonoma:        "bfff7b69bf67956139c9e3f2e00ea00fe9f53baa541e05ec6699b5490074728b"
    sha256 arm64_linux:   "80dd1ed6b479814ce5119818964446c1bd6aa6a3783e46a7b6b83fdc8a474eb7"
    sha256 x86_64_linux:  "95c4d44868122787004f3ec4f0157bd221827fde3d6ae58885032721dd596dd2"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  on_macos do
    depends_on "gettext"
  end

  # Fix build with Perl 5.40+
  # Upstream PR ref: https://github.com/irssi/irssi/pull/1573
  patch do
    url "https://github.com/irssi/irssi/commit/6395b93cc8461f8a3da1877c18b4abff490a3965.patch?full_index=1"
    sha256 "55b68fe2ae2e7c893cea2ffb1ccdfd6e52b3c6658d26cd5d46ec8612723bd3a8"
  end

  def install
    args = %W[
      --sysconfdir=#{etc}
      --with-proxy
      --enable-true-color
      --with-socks=no
      --with-perl=yes
      --with-perl-lib=#{lib}/perl5/site_perl
    ]

    system "./configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
    # "make" and "make install" must be done separately on some systems
    system "make"
    system "make", "install"
  end

  test do
    require "pty"

    assert_match version.to_s, shell_output("#{bin}/irssi --version")

    stdout, = PTY.spawn("#{bin}/irssi -c irc.freenode.net -n testbrew")
    assert_match "Terminal doesn't support cursor movement", stdout.readline

    # This is not how you'd use Perl with Irssi but it is enough to be
    # sure the Perl element didn't fail to compile, which is needed
    # because upstream treats Perl build failures as non-fatal.
    # To debug a Perl problem copy the following test at the end of the install
    # block to surface the relevant information from the build warnings.
    ENV["PERL5LIB"] = lib/"perl5/site_perl"
    system "perl", "-e", "use Irssi"
  end
end
