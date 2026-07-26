class Atari800 < Formula
  desc "Atari 8-bit machine emulator"
  homepage "https://atari800.github.io/"
  url "https://github.com/atari800/atari800/releases/download/ATARI800_7_1_2/atari800-7.1.2-src.tgz"
  sha256 "9602badfd7c45551cb5c4cc77f862af377c43a07caaa0bfc77ac87f9179673e3"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^ATARI800[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0b7f9342ba2870c4173d6d9a7a84a8ac1472a467c7f42bcc0c2204d555b0a6a8"
    sha256 cellar: :any, arm64_sequoia: "54027c3161ae2f09b6f4e27b9bf970dcfb902118ffa2d2a70cb05059495ff536"
    sha256 cellar: :any, arm64_sonoma:  "5bb851cf8e02f40c858987c5416a3a8ca2f66bbc35fc4d4218faa5e502a8233a"
    sha256 cellar: :any, sonoma:        "6a0c1b2ea53c565ecc33b48bd582259636c1ca982dbd5996285ef569d037de28"
    sha256 cellar: :any, arm64_linux:   "8865bf50cd8bb64455f3dff830b632ea1039c6fa36d186c850c956b5ae5330e3"
    sha256 cellar: :any, x86_64_linux:  "ff764a55b77265850d1798bf1765a382dcd3fa3f915f7cbc9d3b371f4566358c"
  end

  head do
    url "https://github.com/atari800/atari800.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libpng"
  depends_on "sdl2-compat"

  on_linux do
    depends_on "readline"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-sdltest",
                          "--disable-riodevice",
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    assert_equal "Atari 800 Emulator, Version #{version}",
                 shell_output("#{bin}/atari800 -v", 3).strip
  end
end
