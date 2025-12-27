class Gpredict < Formula
  desc "Real-time satellite tracking/prediction application"
  homepage "https://oz9aec.dk/gpredict/"
  url "https://github.com/csete/gpredict/releases/download/v2.4/gpredict-2.4.tar.bz2"
  sha256 "c479b156496f65ef03c073f3483796f39507e35b996c33214c65698fc4bd8923"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "00a4b8168a49d8832067ae38062fbb27ee4832128dd1477ca0c04d9121e1b018"
    sha256 arm64_sequoia:  "4403289b0462934585554618873510ff96c04fde9853e6aeb3ddc048fd98ba31"
    sha256 arm64_sonoma:   "a2f0896b69d12cc6fcefff733bb0c1f8dad89309125453ad660b3bca6d6bfb1d"
    sha256 arm64_ventura:  "6e7826d912ce8ab58e41957be7c2f5430e72a8dd1d4e12da7c1500e167c3135a"
    sha256 arm64_monterey: "10d957077407004e9a1f24871417521fc89ce9400a28880d606357d6c97b9153"
    sha256 sonoma:         "1f22599c86203b19a4a41d0b99b8a149ba6a5453f77f870af3febc88b41b8086"
    sha256 ventura:        "e87506b7e96f33c83ba138514835c060ea7f8574a2c85547264c03fe666ae5bc"
    sha256 monterey:       "ba26824909be3fb95aceca85485c8e858071f1e0ad861c7c9e541630859a1dc4"
    sha256 arm64_linux:    "e225f47753f56821f579153f77e91f03dce0150f9065bf2f4d962987eaaa7980"
    sha256 x86_64_linux:   "e81cbab517c5a422abe3f0cc1a2fdac16b9c6d118949d343dfd30cd4d5026e8d"
  end

  head do
    url "https://github.com/csete/gpredict.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "goocanvas"
  depends_on "gtk+3"
  depends_on "hamlib"
  depends_on "pango"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    if build.head?
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh", *std_configure_args
    else
      system "./configure", *std_configure_args
    end
    system "make", "install"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "real-time", shell_output("#{bin}/gpredict -h")
  end
end
