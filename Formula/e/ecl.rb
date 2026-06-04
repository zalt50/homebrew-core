class Ecl < Formula
  desc "Embeddable Common Lisp"
  homepage "https://ecl.common-lisp.dev"
  url "https://ecl.common-lisp.dev/static/files/release/ecl-26.5.5.tgz"
  sha256 "a01a5bcda8c5b73e59dda3494fd13e5fec5db6aa1dad782c3cc3bb57f1633435"
  license "LGPL-2.1-or-later"
  head "https://gitlab.com/embeddable-common-lisp/ecl.git", branch: "develop"

  livecheck do
    url "https://ecl.common-lisp.dev/static/files/release/"
    regex(/href=.*?ecl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "edb63f5914ae4e9825d1f836dc636555a4dd0b80b1e01ffa7bd0ec8209139b58"
    sha256 arm64_sequoia: "606fd1bdc296fe92a7ae4998159db7a554fef0d7dcd5cf9b719adf30dc7c9a0d"
    sha256 arm64_sonoma:  "e9e3eb11a37604482848a41ba921deb895ee0b7ebe60e36d3a735f1b7eb411a8"
    sha256 sonoma:        "831d24ba6b467b341eb24a5242594cf672485094fd1b91645db24e94ad2b5823"
    sha256 arm64_linux:   "25f1e1e060eeeda2f8b7e51f67114a46d10efe965e186d79523a5ba6a94f0e56"
    sha256 x86_64_linux:  "a2de5f52b9cd228f9ee0be9d20d0d441697e2f89afa8d1fbd476a6dd1198c960"
  end

  depends_on "texinfo" => :build # Apple's is too old
  depends_on "bdw-gc"
  depends_on "gmp"

  uses_from_macos "libffi"

  # does not build on macOS 14
  on_macos do
    on_intel do
      depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600

      fails_with :clang do
        build 1600
        cause "Unhandled lisp initialization error"
      end
    end
  end

  def install
    ENV.deparallelize
    # avoid saving llvm_clang or gcc-X inside binaries as these may not be available
    ENV["CC"] = DevelopmentTools.default_compiler.to_s if ENV.compiler != :clang

    libffi_prefix = if OS.mac?
      MacOS.sdk_path
    else
      Formula["libffi"].opt_prefix
    end
    system "./configure", "--enable-threads=yes",
                          "--enable-boehm=system",
                          "--enable-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
                          "--with-libffi-prefix=#{libffi_prefix}",
                          "--with-libgc-prefix=#{Formula["bdw-gc"].opt_prefix}",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"simple.cl").write <<~LISP
      (write-line (write-to-string (+ 2 2)))
    LISP
    assert_equal "4", shell_output("#{bin}/ecl -shell #{testpath}/simple.cl").chomp
  end
end
