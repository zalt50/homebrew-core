class Strace < Formula
  desc "Diagnostic, instructional, and debugging tool for the Linux kernel"
  homepage "https://strace.io/"
  url "https://github.com/strace/strace/releases/download/v7.2/strace-7.2.tar.xz"
  sha256 "4bde6246926890dcee824f6e6ac42a06752f47d77e5097d86e3c0d6d4b709fe5"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_linux:  "cc0d5376cc5f73c84ef6672c5fd3d4b35e8b52630a76c86e686551ce3841599d"
    sha256 cellar: :any, x86_64_linux: "7288af8e07a581afecfcda30830197cc98a3ed186fba1587d65d192924bd7ea6"
  end

  head do
    url "https://github.com/strace/strace.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on :linux

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--enable-mpers=no", # FIX: configure: error: Cannot enable m32 personality support
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    out = `"strace" "true" 2>&1` # strace the true command, redirect stderr to output
    assert_match "execve(", out
    assert_match "+++ exited with 0 +++", out
  end
end
