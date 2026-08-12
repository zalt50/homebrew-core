class Procps < Formula
  desc "Utilities for browsing procfs"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps/-/archive/v4.0.7/procps-v4.0.7.tar.gz"
  sha256 "468dfe0f29a77498286b459fcc33e24fcc2031c11a890244ba9cf1481a4f5df7"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/procps-ng/procps.git", branch: "master"

  bottle do
    sha256 arm64_linux:  "c0d42a966b121bb5adc0ae6fbd70ad38061fdda92f4e49ecc55ed5ece21bfb03"
    sha256 x86_64_linux: "a1a5259bfa1c75975bab8e502dfe76958c9a4e812ae652a8268c72aa5e4ec984"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on :linux
  depends_on "ncurses"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"

    # kill and uptime are also provided by coreutils
    rm [bin/"kill", bin/"uptime", man1/"kill.1", man1/"uptime.1"]
  end

  test do
    system bin/"ps", "--version"
    assert_match "grep homebrew", shell_output("#{bin}/ps aux | grep homebrew")
  end
end
