class Sdl3Net < Formula
  desc "Simple cross-platform wrapper over TCP/IP sockets"
  homepage "https://github.com/libsdl-org/SDL_net"
  url "https://github.com/libsdl-org/SDL_net/releases/download/release-3.2.0/SDL3_net-3.2.0.tar.gz"
  sha256 "098522fc26d4e302ef9348aee6e76e67fe504dfefd7f596236568f8330570c41"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL_net.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "sdl3"

  uses_from_macos "perl" => :build

  def install
    args = %w[-DSDLNET_INSTALL_MAN=ON -DSDLNET_SAMPLES=OFF]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <SDL3_net/SDL_net.h>
      #include <stdlib.h>

      int main() {
        return NET_Version() == SDL_NET_VERSION ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    C
    system ENV.cc, "test.c", "-I#{Formula["sdl3"].opt_include}", "-L#{lib}", "-lSDL3_net", "-o", "test"
    system "./test"
  end
end
