class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://github.com/NagiosEnterprises/nagioscore/releases/download/nagios-4.5.11/nagios-4.5.11.tar.gz"
  sha256 "1bf85d6704a75e6b89a09844836f68b1cfc61ab1ef005574041e36e73fdb797a"
  license "GPL-2.0-only"
  head "https://github.com/NagiosEnterprises/nagioscore.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "85acb132e68bd3e6ce2ee9b136dc771c6f5e22799d6b0122c3456671e7a64c33"
    sha256 arm64_sequoia: "9646c0ff39a620deeddb386028b140930d4204e62dd67e68d158774c4825c542"
    sha256 arm64_sonoma:  "c9d84510322c0b776b886faf0fe4fb2b1d238a8203751aeb47d18f4875370473"
    sha256 arm64_ventura: "a2fbf4c911c2de1b1d135ef9a29882e21a1f6d7e5ccad4f5dde1d5138a72926b"
    sha256 sonoma:        "d96bd15c74973f9f45dc4b29f0eab5c22ff9dae05206786be854ab9db228759a"
    sha256 ventura:       "2be2887f399a467087b82119aadbb0e392b58736def5696daf328c9284a5ed9d"
    sha256 arm64_linux:   "e4eb8032f20aae59ce984934d3e4d97dace685cbc8b92f30fa7a9dc97fc56839"
    sha256 x86_64_linux:  "17ea83b36c6ff5f2cc372297b7398649f4032afdb56bf5c86ae59d4dd20ba100"
  end

  depends_on xcode: :build
  depends_on "gd"
  depends_on "libpng"
  depends_on "openssl@3"

  uses_from_macos "unzip"

  on_macos do
    depends_on "jpeg-turbo"
  end

  # Fix compilation error on in lib/runcmd.c; https://github.com/NagiosEnterprises/nagioscore/pull/1048
  patch do
    url "https://github.com/NagiosEnterprises/nagioscore/commit/874a7688fca646f14eef17abf744d8561c60c0c2.patch?full_index=1"
    sha256 "c7d3a4a6d5f918a67a7b49f9cd30af45234510ad1697745313dbcfa4ff767ad0"
  end

  def nagios_sbin
    prefix/"cgi-bin"
  end

  def nagios_etc
    etc/"nagios"
  end

  def nagios_var
    var/"lib/nagios"
  end

  def htdocs
    pkgshare/"htdocs"
  end

  def user
    Utils.safe_popen_read("id", "-un").chomp
  end

  def group
    Utils.safe_popen_read("id", "-gn").chomp
  end

  def install
    args = [
      "--sbindir=#{nagios_sbin}",
      "--sysconfdir=#{nagios_etc}",
      "--localstatedir=#{nagios_var}",
      "--datadir=#{htdocs}",
      "--libexecdir=#{HOMEBREW_PREFIX}/sbin", # Plugin dir
      "--with-cgiurl=/nagios/cgi-bin",
      "--with-htmurl=/nagios",
      "--with-nagios-user=#{user}",
      "--with-nagios-group='#{group}'",
      "--with-command-user=#{user}",
      "--with-httpd-conf=#{share}",
      "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
      "--disable-libtool",
    ]
    args << "--with-command-group=_www" if OS.mac?

    system "./configure", *std_configure_args, *args
    system "make", "all"
    system "make", "install"

    # Install config
    system "make", "install-config"
    system "make", "install-webconf"
  end

  def post_install
    (var/"lib/nagios/rw").mkpath

    config = etc/"nagios/nagios.cfg"
    return unless config.exist?
    return if config.read.include?("nagios_user=#{ENV["USER"]}")

    inreplace config, /^nagios_user=.*/, "nagios_user=#{ENV["USER"]}"
  end

  service do
    run [opt_bin/"nagios", etc/"nagios/nagios.cfg"]
    keep_alive true
    require_root true
    log_path File::NULL
    error_log_path File::NULL
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nagios --version")
  end
end
