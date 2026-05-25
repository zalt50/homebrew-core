class Ghcup < Formula
  desc "Installer for the general purpose language Haskell"
  homepage "https://www.haskell.org/ghcup/"
  # There is a tarball at Hackage, but that doesn't include the shell completions.
  url "https://github.com/haskell/ghcup-hs/archive/refs/tags/v0.2.4.0.tar.gz"
  sha256 "645005ecbb3ddc67e8273aea76fdae46d15b05963cb60e3ab03552c2936609f1"
  license "LGPL-3.0-only"
  head "https://github.com/haskell/ghcup-hs.git", branch: "master"

  # Upstream has retagged a version before, so we check releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac6eec77541d816b1c0627ed79d540fdd6d66f6c0c68ff0769a33b3ebbeafba4"
    sha256 cellar: :any,                 arm64_sequoia: "0ce96281ef3148cd34ef114c4b08e1078f56b82b3588cf7fe99ea521008a87bd"
    sha256 cellar: :any,                 arm64_sonoma:  "f22ae4234638b29ff1d0de96faf8ae3b184ee9cfdf3ec2e8c23408f2a3ae3632"
    sha256 cellar: :any,                 sonoma:        "c0402e7f79c8df8fffb29caa272cb35afd458f354288fe55767087261723c9d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "673bfb6b3d70739585dd1c26797398a7aae34c6885af6d014e5cffdfea147510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a441af019f29e58f081f1a927f87b4a7dfd69286d14fcb71c77c20c4ebc7b12"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    # `+disable-upgrade` disables the self-upgrade feature.
    system "cabal", "v2-install", *args, *std_cabal_v2_args, "--flags=+disable-upgrade"

    bash_completion.install "scripts/shell-completions/bash" => "ghcup"
    fish_completion.install "scripts/shell-completions/fish" => "ghcup.fish"
    zsh_completion.install "scripts/shell-completions/zsh" => "_ghcup"
  end

  test do
    assert_match "ghc", shell_output("#{bin}/ghcup list")
    assert_match version.to_s, shell_output("#{bin}/ghcup --version")
  end
end
