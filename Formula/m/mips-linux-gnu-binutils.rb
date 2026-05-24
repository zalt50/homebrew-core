class MipsLinuxGnuBinutils < Formula
  desc "GNU Binutils for mips-linux-gnu cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  sha256 "0f3152632a2a9ce066f20963e9bb40af7cf85b9b6c409ed892fd0676e84ecd12"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    target = "mips-linux-gnu"
    system "./configure", "--target=#{target}",
                          "--infodir=#{info}/#{target}",
                          "--with-system-zlib",
                          "--with-zstd",
                          "--disable-nls",
                          *std_configure_args(libdir: lib/"target")
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test-s.s").write <<~ASM
      .section .text, "ax"
      .set noat
      .globl _start
      _start:
          addiu $v0, $zero, 0
          j $ra
    ASM

    system bin/"mips-linux-gnu-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-tradbigmips",
                 shell_output("#{bin}/mips-linux-gnu-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/mips-linux-gnu-c++filt _Z1fv")
  end
end
