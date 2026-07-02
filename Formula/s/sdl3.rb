class Sdl3 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://libsdl.org/"
  url "https://github.com/libsdl-org/SDL/releases/download/release-3.4.12/SDL3-3.4.12.tar.gz"
  sha256 "f07b958a9ac5020fb7a44cadb957f658b2149c3c8abb4f63145fac9303249db7"
  license "Zlib"
  compatibility_version 1
  head "https://github.com/libsdl-org/SDL.git", branch: "main"

  livecheck do
    url :stable
    regex(/release[._-](\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "beaa74c6c0bde0c77a913c154f68d33d062a8d05e0d2fe5cb41a7840ad14746a"
    sha256 cellar: :any, arm64_sequoia: "ac813140db6558f2477069f62e0dd6a6ba4bf0a0a141902afcf628e28935bbd8"
    sha256 cellar: :any, arm64_sonoma:  "e856f41653b1bc0981455c8f48656dda374adabc132f7f6f1ddc223225f6d9e6"
    sha256 cellar: :any, sonoma:        "c22e7cf7e5edf9743ed35405280c3cca1d8f686ac11bbe502967ea7f07557e93"
    sha256 cellar: :any, arm64_linux:   "96825809d3a7e9c6f6239e31383dfe301a84ebb087897e7d7f2b6d30863e945b"
    sha256 cellar: :any, x86_64_linux:  "417abcbef205879db83aa0e0507c58e65c84db6aa0e1a13fd37a937972c2e27e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  on_linux do
    # Features are built into library if dependency is found at build-time.
    # These are then enabled at runtime if library can be dynamically loaded,
    # so we can provide extra features via build-only dependencies. This includes
    # PipeWire and Wayland used on modern Linux which have large dependency trees.
    depends_on "libxkbcommon" => :build
    depends_on "mesa" => :build
    depends_on "pipewire" => :build
    depends_on "wayland" => :build

    # Runtime dependencies are for older PulseAudio and X11. These are used if
    # running a Linux container on macOS and should have higher compatibility
    depends_on "libx11" => :no_linkage
    depends_on "libxcursor" => :no_linkage
    depends_on "libxext" => :no_linkage
    depends_on "libxfixes" => :no_linkage
    depends_on "libxi" => :no_linkage
    depends_on "libxrandr" => :no_linkage
    depends_on "libxscrnsaver" => :no_linkage
    depends_on "pulseaudio" => :no_linkage
  end

  def install
    inreplace "cmake/sdl3.pc.in", "@SDL_PKGCONFIG_PREFIX@", HOMEBREW_PREFIX

    args = %w[
      -DSDL_TESTS=OFF
      -DSDL_X11_XTEST=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~CPP
      #include <SDL3/SDL.h>
      int main() {
        if (SDL_Init(SDL_INIT_VIDEO) != 1) {
          return 1;
        }
        SDL_Quit();
        return 0;
      }
    CPP
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lSDL3", "-o", "test"
    ENV["SDL_VIDEODRIVER"] = "dummy"
    system "./test"
  end
end
