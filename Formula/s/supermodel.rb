class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://github.com/trzy/Supermodel"
  url "https://github.com/trzy/Supermodel/archive/refs/tags/v0.3a-20251120-git-3e94dd0.tar.gz"
  version "0.3a-20251120-git-3e94dd0"
  sha256 "e6d6d5c7576fcf8c3ce2cfeaa2697850b69a420d647bf5faa7bfdf4cdae00068"
  license "GPL-3.0-or-later"
  head "https://github.com/trzy/Supermodel.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "9ebc9708a1207cf92a01649204cd4f673b63f4df3574ffacda4c29df64b3b0cd"
    sha256 arm64_sequoia: "55806d70707f24311eac885aa6ec3963cc508dbd397b159a7a80611392bb9c9f"
    sha256 arm64_sonoma:  "7c5571842431f0b73847af493d4fe4d79ae4a834954a567f7c6732e3e83c387b"
    sha256 arm64_ventura: "60d857bc4b057fdb6950645b22eb04970bca9e21e5065f44486bbf5dfd4b4754"
    sha256 sonoma:        "8a730dcfcf67bd5091d7b589f9111ae735ec35c939caf14e4e8469be35c2611a"
    sha256 ventura:       "c3d65f9c8c50660fb2f6fe7cdc3cf6e641f6acefdb396088328ec6c103258d11"
    sha256 arm64_linux:   "9a8fbf1e975303f9c7858caa8d2829cf0cce382971ffa6035576bf9fae7b8e71"
    sha256 x86_64_linux:  "9bffc6af81706a65a8355fe1618d9a4062e48ae2ae969d24888d0802434ca38d"
  end

  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    os = OS.mac? ? "OSX" : "UNIX"
    makefile_dir = "Makefiles/Makefile.#{os}"

    ENV.deparallelize
    # Set up SDL2 library correctly
    inreplace makefile_dir, "-framework SDL2", "`sdl2-config --libs`" if OS.mac?

    system "make", "-f", makefile_dir
    bin.install "bin/supermodel"

    (var/"supermodel/Saves").mkpath
    (var/"supermodel/NVRAM").mkpath
    (var/"supermodel/Logs").mkpath
  end

  def caveats
    <<~EOS
      Config, Saves, and NVRAM are located in the following directory:
        #{var}/supermodel/
    EOS
  end

  test do
    system bin/"supermodel", "-print-games"
  end
end
