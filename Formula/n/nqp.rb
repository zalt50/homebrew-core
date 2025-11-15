class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2025.11/nqp-2025.11.tar.gz"
  sha256 "bcd772c39d6446d771260897c5450c559f9ef07539d1c4e622035549e85e832a"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "92440fa773b1718bff64711bd20e83c80227fab069e2be44e6111797d8a6b1a2"
    sha256 arm64_sequoia: "8e231fc6894a806374b4313f62bbd002a50a05b43243eabc976c296566c184b2"
    sha256 arm64_sonoma:  "237c1c1ba229b3dbd2399b83e1fb4be1a70279fd1f9bb31274455be23006c0fc"
    sha256 sonoma:        "e5872e40626a75e65266aed7c42fbd2bc0c87c79e585cb746395212826d1fa70"
    sha256 arm64_linux:   "686016b7828008d2b7ab114367b301b42f76b432079173a5fde255aa3fef7e9c"
    sha256 x86_64_linux:  "3a2f2d8e98d655a79900b45c2b7d370a8af8cf8e284d28d148971e2698074812"
  end

  depends_on "moarvm"

  uses_from_macos "perl" => :build

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with nqp included"

  def install
    ENV.deparallelize

    # Work around Homebrew's directory structure and help find moarvm libraries
    inreplace "tools/build/gen-version.pl", "$libdir, 'MAST'", "'#{Formula["moarvm"].opt_share}/nqp/lib/MAST'"

    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-moar=#{Formula["moarvm"].bin}/moar"
    system "make"
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}/nqp -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    assert_equal "0123456789", out
  end
end
