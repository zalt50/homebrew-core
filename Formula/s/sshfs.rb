class Sshfs < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://github.com/libfuse/sshfs"
  url "https://github.com/libfuse/sshfs/archive/refs/tags/sshfs-3.7.5.tar.gz"
  sha256 "b975121189cb82ed4c675320155a855adf7632abfd7fbdc385ca448d214b581f"
  license any_of: ["LGPL-2.1-only", "GPL-2.0-only"]

  bottle do
    sha256 arm64_linux:  "bbd7c81450476893e5574f06a4d3fa7975156b71d5dbf1ab28ccd3f103e1dfef"
    sha256 x86_64_linux: "07adb364aaf4520dca920a1b0c2ba1af740e222e6026766aaec88ee9715812df"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"sshfs", "--version"
  end
end
