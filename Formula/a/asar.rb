class Asar < Formula
  desc "SNES assembler for applying patches to ROM images or building ROMs"
  homepage "https://github.com/RPGHacker/asar"
  url "https://github.com/RPGHacker/asar/archive/refs/tags/v1.91.tar.gz"
  sha256 "9192664c888d6ed13a96b15ad81cb98e9e0334531bdfaf8f77abd071816a0770"
  license "LGPL-2.0-or-later"

  depends_on "cmake" => :build
  depends_on "make" => :build

  on_sonoma :or_older do
    depends_on "coreutils" => :test # for sha256sum
  end

  def install
    system "cmake", "src", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.asm").write <<~ASM
      org $008000
      db $78,$9C,$00,$42,$9C,$0C,$42

      db "HOMEBREW TEST        "
      db $20

      org $00FFD7
      db $0A

      org $0FFFFF
      db $00
    ASM
    system bin/"asar", "test.asm"
    assert_match "9f044afb5cb6b41dac792d77cb2a7d29a5abf03c80797a96809b08bdfd46685b  test.sfc",
                 shell_output("sha256sum test.sfc")
  end
end
