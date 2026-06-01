class GitAnnex < Formula
  desc "Manage files with git without checking in file contents"
  homepage "https://git-annex.branchable.com/"
  url "https://hackage.haskell.org/package/git-annex-10.20260601/git-annex-10.20260601.tar.gz"
  sha256 "cce20dbea9f1626e0c680267ffb7e5ef2d95a9e0c34bdc7d153c30cb1f5687f8"
  license all_of: ["AGPL-3.0-or-later", "BSD-2-Clause", "BSD-3-Clause",
                   "GPL-2.0-only", "GPL-3.0-or-later", "MIT"]
  head "git://git-annex.branchable.com/", branch: "master"

  livecheck do
    url "https://hackage.haskell.org/package/git-annex"
    regex(/href=.*?git-annex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "69c8fd2fc4266b12446742ca7b6b77d6e64d57fc1f87a450f5b42138ba631338"
    sha256 cellar: :any,                 arm64_sequoia: "41d596a944a902c6691de9f787b7e568c7faeb8fc1fb73b5d08a7493dcdb0153"
    sha256 cellar: :any,                 arm64_sonoma:  "c8614ecd9f5d361669c1174cda7d977da5c37c8049d6a90b5a881b15ae1892fa"
    sha256 cellar: :any,                 sonoma:        "8de13027cdc0d13d8795374ab341b32869423f21a5d8e6151c7578714c906367"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd9b9a167ff6913ccad0b27ee7a7b64de384e860f7f07a022d696f99202622b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9569952fc81d6eced20a02455171b7ab611a464907adea9bb875a291579d8fe8"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "libmagic"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Hide conflicting imports. Probably caused by `--allow-newer` flag
  patch :DATA

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args, "--flags=+S3 +Servant"
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

__END__
diff --git a/Utility/Url.hs b/Utility/Url.hs
index 40fa483..0c1f973 100644
--- a/Utility/Url.hs
+++ b/Utility/Url.hs
@@ -55,7 +55,7 @@ import Utility.Url.Parse
 import qualified Utility.FileIO as F
 
 import Network.URI
-import Network.HTTP.Types
+import Network.HTTP.Types hiding (hAcceptEncoding, hContentDisposition, hContentRange)
 import qualified System.FilePath.Posix as UrlPath
 import qualified Data.CaseInsensitive as CI
 import qualified Data.ByteString as B
