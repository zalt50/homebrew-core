class Foma < Formula
  desc "Finite-state compiler and C library"
  homepage "https://github.com/mhulden/foma"
  # Upstream didn't tag for new releases, issue ref: https://github.com/mhulden/foma/issues/93
  url "https://github.com/mhulden/foma/archive/dfe1ccb1055af99be0232a26520d247b5fe093bc.tar.gz"
  version "0.10.0"
  sha256 "8016c800eca020a28ac2805841cce20562b617ffafe215d53a23dc9a3e252186"
  license "Apache-2.0"

  livecheck do
    url "https://raw.githubusercontent.com/mhulden/foma/refs/heads/master/foma/CHANGELOG"
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "52b664ad631e0e6a8d46deffc2c9021609d47cd6d83b437661a4addf442c9856"
    sha256 cellar: :any,                 arm64_sequoia:  "cac3217fb92f4bdd36f498474518fef5dabd74dbaa606e5ced0cbcea2686f555"
    sha256 cellar: :any,                 arm64_sonoma:   "8e14b1f28eb40350b2f337bd468a4a3971dbfab55ef04c5bc0d4732daf090913"
    sha256 cellar: :any,                 arm64_ventura:  "c5378bb8f0183650512e47377197a74d7603a8f05c6d6e27cc1c67cbc478b524"
    sha256 cellar: :any,                 arm64_monterey: "bad60b2c29b968a05b7c9f7cc7a7d3350bb0dfd831e9f788d2eb1a102dd6403b"
    sha256 cellar: :any,                 arm64_big_sur:  "8cac09b69356887a31f4d2314b9eb7a193ad21858b0cc43ade7d48a485e4b55d"
    sha256 cellar: :any,                 sonoma:         "38e83f4dabe638b27c003cbf55df8d39bb930497bb6966727524dfdae0e53380"
    sha256 cellar: :any,                 ventura:        "dda2e7f7f7aedfd6bb1dccff1a489c0787b8e2b2680969e57525db9c3ba04b8f"
    sha256 cellar: :any,                 monterey:       "45c56570de4b909b5d145bb2f6cb83ef3852d2076150e6d96432c44ed3441f2e"
    sha256 cellar: :any,                 big_sur:        "cdf3b3105f0207ddea3f5b0ba458b650cab22b1ac3db85896631ec5304cc5bf1"
    sha256 cellar: :any,                 catalina:       "dc0a238f67280d9e15e50bc7064669f1715170c9a59d608537ed195801db0c9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "725abcddb8ddd46b7d328624b335a6a0f660c596340cee2ec69c45a68b7e6537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed4b46bd3f62ab26bbb0407019c2989448d3b9df0680ebb87266bdbfe5b3e9c9"
  end

  depends_on "bison" => :build # requires Bison 3.0+

  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "readline"
  end

  conflicts_with "freeling", because: "freeling ships its own copy of foma"

  # Fedora patch for C99 compatibility
  patch do
    url "https://src.fedoraproject.org/rpms/foma/raw/rawhide/f/foma-c99.patch"
    sha256 "af278be0b812e457c72e1538dd985f5247c33141a3ba39cd5ef0871445173f07"
  end

  def install
    cd "foma" do
      system "make"
      system "make", "install", "prefix=#{prefix}"
    end
  end

  test do
    # Source: https://code.google.com/archive/p/foma/wikis/ExampleScripts.wiki
    (testpath/"toysyllabify.script").write <<~EOS
      define V [a|e|i|o|u];
      define Gli [w|y];
      define Liq [r|l];
      define Nas [m|n];
      define Obs [p|t|k|b|d|g|f|v|s|z];

      define Onset (Obs) (Nas) (Liq) (Gli); # Each element is optional.
      define Coda  Onset.r;                 # Is mirror image of onset.

      define Syllable Onset V Coda;
      regex Syllable @> ... "." || _ Syllable;

      apply down> abrakadabra
    EOS

    system bin/"foma", "-f", "toysyllabify.script"
  end
end
