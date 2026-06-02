class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  license "GPL-2.0-or-later"
  revision 1

  stable do
    url "https://github.com/stella-emu/stella/archive/refs/tags/7.0c.tar.gz"
    version "7.0c"
    sha256 "b9309198aa5746cd568e91caaea10bbeab4ca8155493d0243694b41bdb39d7ca"
    depends_on "sdl2"
  end

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_tahoe:   "8ab71c51931ddfdb6b82d247fff9eb58e9942d32fc8c13c0abed4459a58344d9"
    sha256 cellar: :any, arm64_sequoia: "24140c78a4102e4848abe711f49760549cfe2f0ad5a6dd322868d37d0c82c12f"
    sha256 cellar: :any, arm64_sonoma:  "d6de66a30620b32033947bc6ca98b86ccc825526e5d14f3e29cf47a4eadabc4c"
    sha256 cellar: :any, sonoma:        "c7d9e81150b03eed64cd3a3c2255473b8437429feb2a63b9091569f2e5157fed"
    sha256 cellar: :any, arm64_linux:   "37c6ee529603c602a8f17d73731109a8a0d041a360ea2e818ac0f9c857240a19"
    sha256 cellar: :any, x86_64_linux:  "3293d2efacfbe3e6ccd827e518906400430ab70090efcc75558fc0395a60b42c"
  end

  head do
    url "https://github.com/stella-emu/stella.git", branch: "master"
    depends_on "sdl3"
  end

  depends_on "pkgconf" => :build
  depends_on "libpng"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Remove bundled libraries
    inreplace "configure", /^\s*_libsqlite3=no$/, "" if OS.mac?
    rm_r(["src/lib/libpng", "src/lib/sqlite", "src/lib/zlib"])

    system "./configure", "--enable-release", *std_configure_args
    system "make", "install"
  end

  test do
    # "ERROR: Couldn't initialize SDL: No available video device"
    ENV["SDL_VIDEODRIVER"] = "dummy" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "E.T. - The Extra-Terrestrial", shell_output("#{bin}/stella -listrominfo").strip
  end
end
