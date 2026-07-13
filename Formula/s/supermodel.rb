class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20260712-git-fef2b38.tar.gz"
  version "0.3a-20260712-git-fef2b38"
  sha256 "66252473ebaab35f75ba876defc93fe3d4c0ef4694a2e5c7b1ae81f45a5c3b72"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "8caefa29784e10bec7b0d5c2b56224c335fd17cb108c30a71ad0484839d4f361"
    sha256 cellar: :any, arm64_sequoia: "30a0c3e5fcb08ea841e4e02532cfa3502ed76b1a09fc763fd78693b4456cb033"
    sha256 cellar: :any, arm64_sonoma:  "4fccf349cd37905cde410dd78c971284bdd8dfc9057ac7446dcc9ac521adf17c"
    sha256 cellar: :any, sonoma:        "bad3083a9e53bc18a86cc1b25f8930b28bcc8defccc5c254347ec15b5c76ffd6"
    sha256 cellar: :any, arm64_linux:   "7942ee2e3317ff8f134b3a102644782dc1ec17f2720110727355728a38f80e9d"
    sha256 cellar: :any, x86_64_linux:  "d743cefb87a3c9a5c3c0b27a161e31925a7353666752c65caaecf96f72c7ad49"
  end

  depends_on "sdl2-compat"
  depends_on "sdl2_net"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Not using Makefile.OSX as it uses prebuilt frameworks
    system "make", "-f", "Makefiles/Makefile.UNIX", "BIN_DIR=#{bin}"
  end

  test do
    system bin/"supermodel", "-print-games"
  end
end
