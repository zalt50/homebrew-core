class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.10.0.tar.gz"
  sha256 "998e717419c02ee735aea0b8d57f9cbe1112f40f4b947a39ba2611a415b64da0"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "dc90c15c90bc946e83e2ac2c16d581369d838b646848a440704e79ad4c28895b"
    sha256 arm64_sequoia: "5e44f96263daf881300a0f7ddc7fd24489f474d5fc78cd7fdb6e86c264647878"
    sha256 arm64_sonoma:  "4e0d1c438092f0cb48377da1d63ba770b53bde593c8e56a3ebb512076ca2e2da"
    sha256 sonoma:        "8a2ea04d6890bdd86abc07690abb2705930cd5c437a02d440ac876e08d52c936"
    sha256 arm64_linux:   "e4d5588cc85f2e62e4614e7794368fc737a843faef483ee781ad96a734a3f7d0"
    sha256 x86_64_linux:  "f3542aaa9f1c7109bd8bfed76d89e4fe80e5a278b19b5302013029d0e6c2fba1"
  end

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end
