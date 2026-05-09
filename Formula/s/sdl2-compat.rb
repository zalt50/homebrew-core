class Sdl2Compat < Formula
  desc "SDL2 compatibility layer that uses SDL3 behind the scenes"
  homepage "https://github.com/libsdl-org/sdl2-compat"
  url "https://github.com/libsdl-org/sdl2-compat/releases/download/release-2.32.68/sdl2-compat-2.32.68.tar.gz"
  sha256 "401a64f5d0948f0d1a217cfdba4e72ce63d22f7a9fc3751251e0e3a175ff7703"
  license "Zlib"
  head "https://github.com/libsdl-org/sdl2-compat.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "sdl3" => :no_linkage

  def install
    args = ["-DCMAKE_INSTALL_RPATH=#{rpath(target: Formula["sdl3"].opt_lib)}"] if OS.mac?

    # We override install_prefix to make sure substituted CMAKE_INSTALL_FULL_* use
    # HOMEBREW_PREFIX path because most build scripts assume that all SDL modules
    # are installed to the same prefix. Consequently SDL stuff cannot be keg-only
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--prefix", prefix
    (lib/"pkgconfig").install_symlink "sdl2-compat.pc" => "sdl2.pc"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <SDL.h>

      int main(void) {
        if (SDL_Init(SDL_INIT_VIDEO) < 0) {
          SDL_Log("SDL_Init failed: %s", SDL_GetError());
          return 1;
        }
        SDL_Quit();
        return 0;
      }
    C

    flags = shell_output("#{bin}/sdl2-config --cflags --libs").chomp
    refute_match prefix.realpath.to_s, flags
    refute_match opt_prefix.to_s, flags

    system ENV.cc, "test.c", "-o", "test", *flags.split
    ENV["SDL_VIDEODRIVER"] = "dummy"
    system "./test"
  end
end
