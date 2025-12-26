class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://static.crates.io/crates/git-cinnabar/git-cinnabar-0.7.3.crate"
  sha256 "18adcda45eeb4a1e82f28f404f788ed9051125c6fd760e468fd2763f17dd6cfe"
  license all_of: ["MPL-2.0", "GPL-2.0-only"]
  head "https://github.com/glandium/git-cinnabar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "689f393be873a7f8f9fffabb6d618c2ba679170b4b530c89ea368b0d4f1ee89a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43b6e288419e42b47c3f0bc828b7ef796449ee1a72b9fcdaeee2590127961412"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d119195270f57502840d02d39cbf1ef2ba9ee740a491b7101f4671247dcaa059"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ecb128974292deefef42fcbc3f06ba1ab302b9b27d2ecb946ba99654ca02aae"
    sha256 cellar: :any_skip_relocation, sonoma:        "49d5975a0a6808a2eafdc29949ae201b82ea8a393e7693b1cb1fdc4594b7a65a"
    sha256 cellar: :any_skip_relocation, ventura:       "937d2f850837db54a7d2733487261b8d281a597bc6c3678af2616b840f1cf245"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f18878c7fff0d249aac25069057029d1511c6538d5578a9dcac0dba1255491d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "444b8ff4ecfaf21926dedb792e1096172d3ec3d112e32aea11278b62be4d0860"
  end

  depends_on "rust" => :build
  depends_on "mercurial"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build # for curl-sys, not used on macOS
  end

  conflicts_with "git-remote-hg", because: "both install `git-remote-hg` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"git-cinnabar" => "git-remote-hg"
  end

  test do
    system "git", "-c", "cinnabar.check=traceback", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
    assert_path_exists testpath/"hello/hello.c", "hello.c not found in cloned repo"
  end
end
