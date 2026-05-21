class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/source/mediainfo/26.05/mediainfo_26.05.tar.xz"
  sha256 "f852093f9050022d699606eeabb38b24da5523d0212fab64dc4e4d3e46b56de1"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/MediaArea/MediaInfo.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5b5d6d84888dccc491ecfda9b9087a1e6fa2ef28bdcec51f04299acf5f6e9784"
    sha256 cellar: :any,                 arm64_sequoia: "dea2b4bca874c50ca15b8a72b87c64c85547b5fc140dad52a9b4605cdf4423d5"
    sha256 cellar: :any,                 arm64_sonoma:  "12cb1ce62ccc9f7361ef4679096c8f05a192cc104605d0e4b7d08b59b8a227e3"
    sha256 cellar: :any,                 sonoma:        "8ab936fe98aa53c1024b18f3ecf04cd2fdeecb1adbcc8c15217a1295e5a15862"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fb621fe32dd159771322e19da045f1a59edf870d5d23b77b3f8ab3e059facdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3621a21d2d98ecdff68cec1e0cd313c001083e3069c20cc63491ef4a4baf6d6f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libmediainfo"
  depends_on "libzen"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    cd "Project/GNU/CLI" do
      system "autoreconf", "--force", "--install", "--verbose"
      system "./configure", *std_configure_args
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/mediainfo #{test_fixtures("test.mp3")}")
    assert_match <<~EOS, output
      General
      Complete name                            : #{test_fixtures("test.mp3")}
      Format                                   : MPEG Audio
    EOS

    assert_match version.to_s, shell_output("#{bin}/mediainfo --Version")
  end
end
