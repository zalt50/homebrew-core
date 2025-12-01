class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org/"
  url "https://github.com/skvadrik/re2c/releases/download/4.3.1/re2c-4.3.1.tar.xz"
  sha256 "5f5e8a618960f68bb46ee8728ecd4132e1275b595cfc7a48476f977afd01d0cc"
  license :public_domain

  bottle do
    sha256 arm64_tahoe:   "71ef43c036e5c63887d5e8bcea1c9bb34f633f8ab53158f28ca0b94af81a2830"
    sha256 arm64_sequoia: "8af3d368bb97ad1fca52b58385bd33523a8587ed79036b0fdc233a6df0bdb865"
    sha256 arm64_sonoma:  "4fdcab1947266afe8f2ecac94bf80060c75103d370588f61e7f1c85a12d40d30"
    sha256 arm64_ventura: "d45992c2f3023ff4a762e448e3dcd5f2baa66b34868012e3fb77884c28c5cc1c"
    sha256 sonoma:        "dc97c9542c9def4083ca1e4c62f62c10ec407e4706075c05c2e732e1c0deb8c8"
    sha256 ventura:       "06ff78768145b697c5c6d0cee283ac49405df8114bbc74ec05d78ba1e955c208"
    sha256 arm64_linux:   "d8f608d8de18762b59b5f5405d86fc714f08167055e073b766322a748c850c19"
    sha256 x86_64_linux:  "9b743cf994ab2fdc44ef29d35a142f0a4115a045a4e5e6ba07abce9b8cfbba77"
  end

  uses_from_macos "python" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      unsigned int stou (const char * s)
      {
      #   define YYCTYPE char
          const YYCTYPE * YYCURSOR = s;
          unsigned int result = 0;

          for (;;)
          {
              /*!re2c
                  re2c:yyfill:enable = 0;

                  "\x00" { return result; }
                  [0-9]  { result = result * 10 + c; continue; }
              */
          }
      }
    C
    system bin/"re2c", "-is", testpath/"test.c"
  end
end
