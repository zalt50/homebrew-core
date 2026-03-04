class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "https://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.5/logstalgia-1.1.5.tar.gz"
  sha256 "028936e9f663c877d6969ad25f145c7b420797e9a3e01c6c184815ed8309f481"
  license "GPL-3.0-or-later"
  head "https://github.com/acaudwell/Logstalgia.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "47177045aecd41e2bbe86ac76782ea2eefc84901094501d47320e473ba3ab17b"
    sha256 arm64_sequoia: "2039f6f272486b22fb8aff40369f21ab925b7182b28cda00c8c376d7ec52b8ce"
    sha256 arm64_sonoma:  "dd785c1059352d89129e483d132357f4bf9bc2552edba5024f2febe03c10554e"
    sha256 sonoma:        "351c54e61da905e6218def44e302faeea0191a0bacf292ca2e982c0844fea6cc"
    sha256 arm64_linux:   "fc45e511347222ea545ac70e7835ab62835fc0777241d8365ae6b990d6c89f76"
    sha256 x86_64_linux:  "babb61947b8cf02f61630bd8c6634571594a8e194f78fd27e0604c687d42816c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "glm" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre2"
  depends_on "sdl2"
  depends_on "sdl2_image"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    ENV.cxx11 # to build with boost>=1.85

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Logstalgia v1.", shell_output("#{bin}/logstalgia --help")
  end
end
