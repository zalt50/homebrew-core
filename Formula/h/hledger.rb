class Hledger < Formula
  desc "Easy plain text accounting with command-line, terminal and web UIs"
  homepage "https://hledger.org/"
  url "https://github.com/simonmichael/hledger/archive/refs/tags/1.50.4.tar.gz"
  sha256 "673a3cab0c98c96b4986a939d127641cbea428842910075d095396a20761b151"
  license "GPL-3.0-or-later"
  head "https://github.com/simonmichael/hledger.git", branch: "master"

  # A new version is sometimes present on Hackage before it's officially
  # released on the upstream homepage, so we check the first-party download
  # page instead.
  livecheck do
    url "https://hledger.org/install.html"
    regex(%r{href=.*?/tag/(?:hledger[._-])?v?(\d+(?:\.\d+)+)(?:#[^"' >]+?)?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6dff0cbd1fdfcb2bb2db88506c70fce9daa72f08bc2ff398eba470e869d4fb88"
    sha256 cellar: :any,                 arm64_sequoia: "389a0c69a63f3f904b7012c9ff5c7673c2782a625a9c41e7150c5fcd52cdccff"
    sha256 cellar: :any,                 arm64_sonoma:  "a309ca602adb98d1efaad0f7c5b428776d55f413654b13717ed47cf1064da67c"
    sha256 cellar: :any,                 sonoma:        "7d2440f3cf95172dd45fe71bed7c36bec77e5efb6987ab716c6325f9d122b6da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f281762c39d77ab34945839d2e9634772dac8ec7a3cf442f85ff7c7e70bc075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2e4f5cbc266c52b97bc572aafc3c554cb9ef067fecfccfae4ab48b7ba1a40e6"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "stack", "update"
    system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"
    man1.install Dir["hledger*/*.1"]
    info.install Dir["hledger*/*.info"]
    bash_completion.install "hledger/shell-completion/hledger-completion.bash" => "hledger"
  end

  test do
    system bin/"hledger", "test"
    system bin/"hledger-ui", "--version"
    system bin/"hledger-web", "--test"
  end
end
