class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20261026/git-annex-10.20261026.tar.gz"
  sha256 "fc080a8a556d364e3e9e6255e4ec1540cc53d568df01de30d93d4322e311d028"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  livecheck do
    url "https://hackage.haskell.org/package/git-annex"
    regex(/href=.*?git-annex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "82bcafa08036c3500a4a3ef3513e46a87d9880c04d956429f7410c5cdc71c0e8"
    sha256 cellar: :any, arm64_tahoe:       "3cf0079d69edb939ed9fa2c62d1047e365468871ad32884140f8b95398119289"
    sha256 cellar: :any, arm64_sequoia:     "5191032f8439c349cd57521c142d1c117db78fc14429edef5a7d357f4613ffdf"
    sha256 cellar: :any, arm64_linux:       "bcf13b933258e257174bc2c87e2e8931bdbfc0d966e40942d81e152c6e852cf7"
    sha256 cellar: :any, x86_64_linux:      "e038845f7d295164ef47c687622e6cc57e6db8127dcf82bc3a1ad01e6d6763c3"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "libmagic"

  uses_from_macos "libffi"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :build

  def install
    args = [
      # Workaround to build with GHC 9.14
      "--allow-newer=base,template-haskell",
      # Workaround build failing if memory flag falls back to negated resolution
      "--constraint=aws<0.25.3",
      # Unbundle sqlite
      "--constraint=persistent-sqlite +systemlib +use-pkgconfig",
    ]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
    bin.install_symlink "git-annex" => "git-annex-shell"
    bin.install_symlink "git-annex" => "git-remote-annex"
    bin.install_symlink "git-annex" => "git-remote-tor-annex"
  end

  service do
    run [opt_bin/"git-annex", "assistant", "--autostart"]
  end

  test do
    # make sure git can find git-annex
    ENV.prepend_path "PATH", bin

    system "git", "init"
    system "git", "annex", "init"
    (testpath/"Hello.txt").write "Hello!"
    refute_predicate (testpath/"Hello.txt"), :symlink?
    assert_match(/^add Hello.txt.*ok.*\(recording state in git\.\.\.\)/m, shell_output("git annex add ."))
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert_predicate (testpath/"Hello.txt"), :symlink?

    # make sure the various remotes were built
    assert_match "remote types: git gcrypt p2p S3 bup directory rsync web bittorrent " \
                 "webdav adb tahoe glacier ddar git-lfs httpalso borg rclone hook external",
                 shell_output("git annex version | grep 'remote types:'").chomp

    # The steps below are necessary to ensure the directory cleanly deletes.
    # git-annex guards files in a way that isn't entirely friendly of automatically
    # wiping temporary directories in the way `brew test` does at end of execution.
    system "git", "rm", "Hello.txt", "-f"
    system "git", "commit", "-a", "-m", "Farewell!"
    system "git", "annex", "unused"
    assert_match "dropunused 1 ok", shell_output("git annex dropunused 1 --force")
    system "git", "annex", "uninit"
  end
end
