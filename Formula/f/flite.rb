class Flite < Formula
  desc "Small fast and portable speech synthesis system"
  homepage "http://www.festvox.org/flite"
  url "https://github.com/festvox/flite/archive/refs/tags/v2.2.tar.gz"
  sha256 "ab1555fe5adc3f99f1d4a1a0eb1596d329fd6d74f1464a0097c81f53c0cf9e5c"
  # The `:cannot_represent` is for:
  # * Sun Microsystems, Inc. license (e.g. src/speech/g72x.c)
  # * BSD license with 2 clauses but not matching BSD-2-Clause (e.g. src/speech/rateconv.c)
  license all_of: ["MIT-Festival", "BSD-2-Clause", "BSD-3-Clause", "Spencer-86", "Apache-2.0", :cannot_represent]
  head "https://github.com/festvox/flite.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # Workaround a bug for macOS build. See https://github.com/festvox/flite/pull/21
  on_macos do
    depends_on "coreutils" => :build
  end

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac?

    system "./configure", "--disable-silent-rules",
                        "--with-lex",
                        "--with-vox",
                        *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"flite", "-t", "Hello, Homebrew!", "test.wav"
    assert_path_exists testpath/"test.wav"
  end
end
