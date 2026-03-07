class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://hackage.haskell.org/package/hpack-0.39.2/hpack-0.39.2.tar.gz"
  sha256 "a9370e59a57b0bf52d600bb3941161de7e3f96892f70ee140c1f892b5da7c05d"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6d24fee8d0bbb3e9e5effcf8ab18f845e9f31c2f769925496fbb109c887e4c61"
    sha256 cellar: :any,                 arm64_sequoia: "e0576352e01db128281fd5cf4944185c5199dc00f23a147a11a51c7f33b0f201"
    sha256 cellar: :any,                 arm64_sonoma:  "e3dc50702b68bb461844321420793be6006cfbf9e2c41046e3df0fe3f9bf8770"
    sha256 cellar: :any,                 sonoma:        "10acf47f872a22560f35cdfef1b78682691bc7d05d862d64892c99778c08016c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d98373f8b719147e0755b980225eead700cccc7c7a05e6ff63cec7cb49fb23e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8eb68c22ecd1373502fd2f657f99e26afa7f3cfce4700954130e7912529e213"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    # https://github.com/sol/hpack/pull/642
    odie "Remove constraint!" if build.stable? && version > "0.39.2"
    args << "--constraint=crypton<1.1"

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  # Testing hpack is complicated by the fact that it is not guaranteed
  # to produce the exact same output for every version.  Hopefully
  # keeping this test maintained will not require too much churn, but
  # be aware that failures here can probably be fixed by tweaking the
  # expected output a bit.
  test do
    (testpath/"package.yaml").write <<~YAML
      name: homebrew
      dependencies: base
      library:
        exposed-modules: Homebrew
    YAML
    expected = <<~EOS
      name:           homebrew
      version:        0.0.0
      build-type:     Simple

      library
        exposed-modules:
            Homebrew
        other-modules:
            Paths_homebrew
        build-depends:
            base
        default-language: Haskell2010
    EOS

    system bin/"hpack"

    # Skip the first lines because they contain the hpack version number.
    assert_equal expected, (testpath/"homebrew.cabal").read.lines[6..].join
  end
end
