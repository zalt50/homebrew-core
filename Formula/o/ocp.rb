class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-3.1.1.tar.xz"
  sha256 "33f5c780058eaf8098916b92ee4676c3d6bfce1a2abed39c19cd38154fdccba7"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4f8cd8eaae6ce1f2faaa7fb5e7cebd035adad38c3157b15909f2a05d26f3b118"
    sha256 arm64_sequoia: "91d33fe0137ccd8a79cb3419fcb61925135333944dcf031546efc859e28ed89c"
    sha256 arm64_sonoma:  "7d079e34e69bc73e5cb3bdcbb998c1fc647f1c7bb6e22a39715e3530170cad1a"
    sha256 arm64_ventura: "4423dcac99faa9af574011771a2ef04b3e45d573ed6e0c836c5ddf28fdaf13e2"
    sha256 sonoma:        "20d4860786caf5f9c84a3def8e2e87501f72c896247c689c0de3735168950984"
    sha256 ventura:       "de51895938a849610a1d82aa709256b1f03ba2c1f67cdf4ec9caa21f3439d890"
    sha256 arm64_linux:   "3c6d30c6242aab1ee18d325645f162377ab18324ada0d6b4e5a01165a5cb0f14"
    sha256 x86_64_linux:  "1d624e55ecfc0b8b13c788690519f474588b41f7fe3960bd57e39f3371d5cbe5"
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
  depends_on "sdl2"

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libogg"
  end

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
    depends_on "alsa-lib"
  end

  # Fix qoaplay.c:226:5: error: expected expression
  # PR ref: https://github.com/mywave82/opencubicplayer/pull/147
  resource "unifont" do
    url "https://ftpmirror.gnu.org/gnu/unifont/unifont-16.0.02/unifont-16.0.02.tar.gz"
    sha256 "f128ec8763f2264cd1fa069f3195631c0b1365366a689de07b1cb82387aba52d"
  end

  patch do
    url "https://github.com/mywave82/opencubicplayer/commit/9afa7489578258e6f07196a177dcbb7aa014ffe2.patch?full_index=1"
    sha256 "f6dfa4da0815e5dd70ba7463c0ebbfb4e1a1965f9cac70e63e897c3b3dfe1c9c"
  end

  # pin to 16.0.02 to use precompiled fonts
  # https://github.com/mywave82/opencubicplayer/blob/master/mingw/versionsconf.sh#L20

  def install
    # Required for SDL2
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
