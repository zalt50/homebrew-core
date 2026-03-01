class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-3.2.0.tar.xz"
  sha256 "c2f6fe7edc89a2625ae22f88628f9bc294621cb49efaacb1cd42a4005920098a"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "2d23e0b0530d6bafafef1259a1fff14c2916dd79a870bb7b27756624d3b35350"
    sha256 arm64_sequoia: "f01b64978bdb81b847488dc78660843931c48b2ad6b1aefe6eb16c8b1847cf63"
    sha256 arm64_sonoma:  "25b6f1b7d06c8bac738883be72159dbc678d6cf9c7f5dc32e97769f071dc77ad"
    sha256 sonoma:        "92b55ed46999d3426fde9c7c8760875ad5122fee38b5701f756f1fe19aea2a0c"
    sha256 arm64_linux:   "9ab4e98fe3824a0e1368452702963e872da9d9e13a85237a5a36b519bc362f71"
    sha256 x86_64_linux:  "935e516dcc588bb438eee0531c18242d49a4d3b532ff6579c3302b5de37f39d5"
  end

  depends_on "pkgconf" => :build
  depends_on "xa" => :build

  depends_on "ancient"
  depends_on "cjson"
  depends_on "flac"
  depends_on "freetype"
  depends_on "game-music-emu"
  depends_on "jpeg-turbo"
  depends_on "libdiscid"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl3"

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"

  on_macos do
    depends_on "libogg"
  end

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
    depends_on "alsa-lib"
    depends_on "zlib-ng-compat"
  end

  # https://github.com/mywave82/opencubicplayer/blob/master/mingw/versionsconf.sh#L20
  resource "unifont" do
    url "https://ftpmirror.gnu.org/gnu/unifont/unifont-17.0.03/unifont-17.0.03.tar.gz"
    sha256 "9a26aa9adfa8eb1f91b0cd9b83e7f95ea9e14c6e85be71aa3ab0df5cb4e69c35"
  end

  # Fix clang parse failure for declarations after labels, upstream PR ref, https://github.com/mywave82/opencubicplayer/pull/168
  patch do
    url "https://github.com/mywave82/opencubicplayer/commit/af5e034a317abbf5e352fd371308fae47d0d1e58.patch?full_index=1"
    sha256 "1c0d58d4097e1d439718b0eddfdf46c60f53721f3b66c9bf180b566de3f342f0"
  end

  def install
    # Required for SDL3
    resource("unifont").stage do |r|
      cd "font/precompiled" do
        share.install "unifont-#{r.version}.otf" => "unifont.otf"
        share.install "unifont_csur-#{r.version}.otf" => "unifont_csur.otf"
        share.install "unifont_upper-#{r.version}.otf" => "unifont_upper.otf"
      end
    end

    args = %W[
      --prefix=#{prefix}
      --without-x11
      --without-desktop_file_install
      --without-update-mime-database
      --without-update-desktop-database
      --with-unifontdir-ttf=#{share}
      --with-unifontdir-otf=#{share}
    ]

    # We do not use *std_configure_args here since
    # `--prefix` is the only recognized option we pass
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocp --help 2>&1")

    assert_path_exists testpath/".config/ocp/ocp.ini"
  end
end
