class Ngrep < Formula
  desc "Network grep"
  homepage "https://github.com/jpr5/ngrep"
  url "https://github.com/jpr5/ngrep/archive/refs/tags/v1.48.0.tar.gz"
  sha256 "49a20b83f6e3d9191c0b5533c0875fcde83df43347938c4c6fa43702bdbd06b4"
  license :cannot_represent # Described as 'BSD with advertising' here: https://src.fedoraproject.org/rpms/ngrep/blob/rawhide/f/ngrep.spec#_8

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1b67e183459765781fe9dcebd26d2e1ceb7de1038c71506c71be704b5d0a9bbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a2f5ada3b9c16b15c122b7a749d12ec3f52e65b710e6cc8f4ea03f81a4eb0a3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1065c49a35fa2a04d53e7f7e46a622776697eb3545e7d9fc04836d50aa816339"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6eb14e55176c89bc45e0cda15f725b5ff35d15d8dc017a5bf47609c763964271"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9539b7c9783bce244c1310c691766b6c14fbc9a1c0b00ed9b480ed41575717d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5bc88f61eaba46026963de70f44e84f73f04b041e913051fb21f3351d16cd9e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b377219b442558f62cd2dd1ce4fbf71ca5daa93e5352712870cd9bfe15c7a0a"
    sha256 cellar: :any_skip_relocation, ventura:        "2f7aa884659d815ab2ace822663bd3a444ef90b8580dfe1ece26b4a93eacc79f"
    sha256 cellar: :any_skip_relocation, monterey:       "b7f33fabe9f42533580c021d441d4ef8132150c345add38cf9fc6452efa611a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ab0d459dad3462b127af805de369dac2f099844126d70e89e531ea181d0e794"
    sha256 cellar: :any_skip_relocation, catalina:       "53bf6d68b15a2f07a01d828cdcd137131a45871141da411328c376ed90768265"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c5118b8b54a6577bbf48d50a9fe39309a39461336dacb5aee639f89ceb978ec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b54a418af69d95d16a04604e385faa40791e6ae6bc488a7f146b0f22a2845a5b"
  end

  depends_on "libpcap"
  depends_on "pcre2"

  def install
    args = [
      "--enable-ipv6",
      "--enable-pcre2",
      "--prefix=#{prefix}",
    ]

    args << "--with-pcap-includes=#{Formula["libpcap"].opt_include}"

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ngrep -V")
  end
end
