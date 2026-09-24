class LinuxPam < Formula
  desc "Pluggable Authentication Modules for Linux"
  homepage "https://github.com/linux-pam/linux-pam"
  url "https://github.com/linux-pam/linux-pam/releases/download/v1.7.3/Linux-PAM-1.7.3.tar.xz"
  sha256 "2ce4765fd49df6693771ef2941f81e33d8ee14b94a81a5c7b369aa3b137b85a5"
  license any_of: ["BSD-3-Clause", "GPL-1.0-only"]
  head "https://github.com/linux-pam/linux-pam.git", branch: "master"

  bottle do
    sha256 arm64_linux:  "3e541f42f80d3d7f993b99967fb4a148d48bc036d6bcf975969eb102aa26cdd0"
    sha256 x86_64_linux: "1320fdd62af4198e52f35271742e0b91db573f4429edffad6c44dcc0cf169663"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libnsl"
  depends_on "libtirpc"
  depends_on "libxcrypt"
  depends_on :linux

  def install
    system "meson", "setup", "build", "--sysconfdir=#{etc}", "-Dvendordir=#{pkgshare}/security",
"-Dsecuredir=#{lib}/security", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "Usage: #{sbin}/mkhomedir_helper <username>",
                 shell_output("#{sbin}/mkhomedir_helper 2>&1", 14)
  end
end
