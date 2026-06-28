class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  # NOTE: If the build fails due to dependency resolution, do not report issue
  # upstream as we modify upstream's constraints in order to use a newer GHC.
  url "https://github.com/purescript/purescript/archive/refs/tags/v0.15.16.tar.gz"
  sha256 "36abaef46aa3cd0316d924c872987aa186d95654d05aa66060948ab47b161f18"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/purescript/purescript.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "6816c04335a5db15f75e148c2c5a32bda26768b80d0b5ff76162a50c568adf6d"
    sha256 cellar: :any,                 arm64_sequoia: "035715c84e56262a479fb1ea36540aad9a5eabf6c7df5f8492c22d1bb060d50c"
    sha256 cellar: :any,                 arm64_sonoma:  "c632a186c55a5a4031ab0c935965987506489b165e4b497d55bb1898cd102ffa"
    sha256 cellar: :any,                 sonoma:        "307a30f58a38fe6991b6362d5f36d8b22094d595aefce3b4630566ee0e03180f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71a6893562316ed81a0b374eb74754435d0f512b727d3430952232d24e8ba397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ab1488698c461b43eb948dc0dcd752ea4cdad6216ce45ef809b5d49209bf0c7"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Minimal set of dependencies that need to be unbound to build with newer GHC
    args = ["--allow-newer=base,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    test_module_path = testpath/"Test.purs"
    test_target_path = testpath/"test-module.js"
    test_module_path.write <<~PURESCRIPT
      module Test where

      main :: Int
      main = 1
    PURESCRIPT
    system bin/"purs", "compile", test_module_path, "-o", test_target_path
    assert_path_exists test_target_path
  end
end
