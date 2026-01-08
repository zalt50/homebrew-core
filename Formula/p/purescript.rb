class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git", branch: "master"

  stable do
    # TODO: Switch back to hackage in next release and remove livecheck
    # url "https://hackage.haskell.org/package/purescript-0.15.15/purescript-0.15.15.tar.gz"
    #
    # NOTE: If the build fails due to dependency resolution, do not report issue
    # upstream as we modify upstream's constraints in order to use a newer GHC.
    url "https://github.com/purescript/purescript/archive/refs/tags/v0.15.15.tar.gz"
    sha256 "7f6c5b1025f1dfa3b74f6fd11133d8472cb5297038619ce2bd00dea99af8127a"

    # Backport commits to build with GHC 9.6 and 9.8
    patch do
      url "https://github.com/purescript/purescript/commit/851291e0fff69c24ef714f24653defa978c381e5.patch?full_index=1"
      sha256 "d6aa719823d77ef5db9db0f45a4ba98c45c79f3d45a28ca36cf452d7311a9b84"
    end
    patch do
      url "https://github.com/purescript/purescript/commit/2070d479d133da9a7c33f7572ca7adb45a4c7aee.patch?full_index=1"
      sha256 "4410112a011c6fb72a776a0dc34ca839ea637c1654598c9a395936faf53b8f0e"
    end
    patch do
      url "https://github.com/purescript/purescript/commit/08b6c758b53fface1769c05ca8bcf119db5c114c.patch?full_index=1"
      sha256 "e4502a0305b058d6e6a04309e1cddbf064103c0f1f2e63f369ef36af2033312a"
    end
    patch do
      url "https://github.com/purescript/purescript/commit/48be80d01d904bd3b2cf575ef0e61057c640ea22.patch?full_index=1"
      sha256 "79b3760cd626eb6f6c3612c18ac5a251bc7508f4b549ceb4951e32f5b8dc0f98"
    end
    patch do
      url "https://github.com/purescript/purescript/commit/377bdbde43d5aea46debbb9e90aa833ab6442f41.patch?full_index=1"
      sha256 "3b3b840d543b751bd5f93288dfb622139203d1a1e3c1b6461d14f8bdc6af1742"
    end
    patch do
      url "https://github.com/purescript/purescript/commit/2b7164ff852b7243cd6d25529bc43a37162099ef.patch?full_index=1"
      sha256 "7b911c1b46ac18acea156457f1ada1cbc57af9ca90d331354b96a4da553a4121"
    end
    patch do
      url "https://github.com/purescript/purescript/commit/9dd761a3805a0c04b90db915599c1c6d8a3bb68e.patch?full_index=1"
      sha256 "c1beaec811967c6adad689e32f5f85af03be41e2d4f648ba4f52002b6ffa00ab"
    end
    patch do
      url "https://github.com/purescript/purescript/commit/e06b9ccb7cbf31633d25e55531d70dcda7ec28b2.patch?full_index=1"
      sha256 "810a6cf537a056e3588a66da11bbe433982dc29c5e7ced209e4b6cf5b7c6e9c1"
    end
  end

  # Add default hackage livecheck until original URL is restored.
  livecheck do
    url "https://hackage.haskell.org/package/purescript/src/"
    regex(%r{<h3>purescript-(.*?)/?</h3>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "2b9aeb3f72c90bcf7747ac0000e2609b7d39ad535d00a7ba733dd40f51dbcb5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3c1767c6fe89d2e486911f5c60c81222996c3b47971d57b533bb57ace2d22a4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69551d14eb101c3640582d055929b2d6338310c5422530edb2b1e35dbd648830"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "720d717ad6d38ba67c288cca2cc03b236cf29ed3badeb823743d1ab091f8704f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d4a9daf4fca5b870a4e45590a13e56e8e78f9bef3729047f064a48a86e7e3f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "133fd37b35ea0ebc610965f55332f02bbf67a00db14c4b518f9e7b714fdd705f"
    sha256 cellar: :any_skip_relocation, ventura:        "25f3df8f4c4e5eaf94f4fb9411dfcd48ffaaf257f96e454eef88ff387dd7bc8d"
    sha256 cellar: :any_skip_relocation, monterey:       "a5cf0585bded8ce93f09124d885a8dc00b373b6ca63407300d5b3bcc10aebe9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b63d16bc91ca4f7bb745607399bf01273f7a4b31afb689ea10b7db7ac43bd13e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c07fee914dfa9648df6df6152b7c5d7f0297d2e8133a653a4f3511dcfb72b01c"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
