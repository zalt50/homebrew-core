class Openkermit < Formula
  desc "Scriptable network and serial communication for UNIX and VMS"
  homepage "https://www.openkermit.org/"
  url "https://github.com/openkermit/ckermit/archive/refs/tags/v11.0.507.tar.gz"
  sha256 "45070b3fb0f9eda87e8a3b9126b110aed8fe4f561bf803e4fd856dbc367d9b0a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bb49244a3197278ad616a1db7bc66d6265b83df118069eac598db528e8cf0ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dfeaf19da1b723218fcb3755388148defd26f5d75de504eab8daae70a37d1f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e23842bab8d10800310dd946ecf9647cc02d13ec40527eaea46241e08731b8fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "b22b75855c0f19b7d532f7e010cf355cbea2e99bc58b2139d30416c7e785d7ad"
    sha256 cellar: :any,                 arm64_linux:   "b41d0c8ec805ecdb8e4a884157c3b2a40c7f8b1444d0a75e9c6d8359458757ae"
    sha256 cellar: :any,                 x86_64_linux:  "1263fff09db1be9d264a60e4cbcbd329896362f08c274016964b291bcc0d78bb"
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
    # /confirm:off keeps this headless.
    system "#{bin}/kermit", "-C",
           "set host /network-type:pseudoterminal \"kermit -x\", get /confirm:off /bin/sh, bye, quit"
    assert_path_exists "sh"
  end
end
