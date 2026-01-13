class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "https://coccinelle.gitlabpages.inria.fr/website/"
  url "https://coccinelle.gitlabpages.inria.fr/website/distrib/coccinelle-1.3.1.tar.gz"
  sha256 "f76ddd4fbe41019af6ed1986121523f0a0498aaf193e19fb2d7ab0b7cdf8eb46"
  license "GPL-2.0-only"
  head "https://github.com/coccinelle/coccinelle.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 3
    sha256 arm64_tahoe:   "6674635eed7e10d0c59addbe4334400c00fce2757a0b976dcf6bc9c26f7a7232"
    sha256 arm64_sequoia: "0faa904330204e02b784ec7e6c99a15617729ad7ac81f6ed66402b6f7e666d12"
    sha256 arm64_sonoma:  "0b15c96cad2e7deb89c174cfe2ee50d29cae1fa30e7dcc622784e7efad86e635"
    sha256 sonoma:        "c3c10e081708afbc74243fe20cb096da013911b3cd7ffe4a0bb759e8c05170ad"
    sha256 arm64_linux:   "fe10716f2b88622a10a28155bf96c10a20ddca724fc73edd6a2b758cd4fe39bc"
    sha256 x86_64_linux:  "2d29e8edd51256bcc58964055ca65ebf75a7ebaf953be4d8300cb127817bdd8a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "menhir" => :build
  depends_on "ocaml" => :build
  depends_on "ocaml-findlib" => :build

  # Apply Fedora patch to allow stdcompat to build with ocaml 5.4.0.
  # When removing patch, also remove autoreconf and make autoconf/automake HEAD-only.
  # Issue ref: https://github.com/ocamllibs/stdcompat/issues/62
  patch do
    url "https://src.fedoraproject.org/rpms/ocaml-stdcompat/raw/2f4345ccea8eda0cd2a4cc33c337a9d92d66eb3c/f/ocaml-stdcompat-ocaml5.4.patch"
    sha256 "f30c8c3d75f9486020c47cf7d1701917e18497c92956b3c11cea79adbbeb7689"
    directory "bundles/stdcompat/stdcompat-current"
  end

  def install
    # Remove unused bundled libraries
    rm_r(["bundles/menhirLib", "bundles/pcre"])

    # Help find built libraries on macOS
    inreplace "bundles/pyml/Makefile", " LD_LIBRARY_PATH=", " DYLD_LIBRARY_PATH=" if OS.mac?

    # TODO: remove when patch is no longer needed
    cd "bundles/stdcompat/stdcompat-current" do
      system "autoreconf", "--force", "--install", "--verbose"
    end

    system "./autogen" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--disable-pcre-syntax", # needs EOL `pcre`
                          "--enable-ocaml",
                          "--enable-opt",
                          "--with-bash-completion=#{bash_completion}",
                          "--with-python=python3",
                          "--without-pdflatex",
                          *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"

    pkgshare.install "demos/simple.cocci", "demos/simple.c"
  end

  test do
    system bin/"spatch", "-sp_file", "#{pkgshare}/simple.cocci", "#{pkgshare}/simple.c", "-o", "new_simple.c"
    expected = <<~C
      int main(int i) {
        f("ca va", 3);
        f(g("ca va pas"), 3);
      }
    C

    assert_equal expected, (testpath/"new_simple.c").read
  end
end
