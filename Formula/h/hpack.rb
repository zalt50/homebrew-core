class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://hackage.haskell.org/package/hpack-0.39.2/hpack-0.39.2.tar.gz"
  sha256 "a9370e59a57b0bf52d600bb3941161de7e3f96892f70ee140c1f892b5da7c05d"
  license "MIT"
  head "https://github.com/sol/hpack.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "36a8b97448a48979d08e475a029314aa6b3a64e8518522c36aed95fbaa6c63f4"
    sha256 cellar: :any,                 arm64_sequoia: "ee93ad2256f2d51f4f680df4ac77a472dcee19452e30258f85c5cbf0ce7d728f"
    sha256 cellar: :any,                 arm64_sonoma:  "ffeea1d858ea77bc72a7e69d407c0e3eb94b09ec936d5b0d9bf7154760785d9a"
    sha256 cellar: :any,                 sonoma:        "585a65118006172fabc3061cd4fb71a66a8abde196f0dd52773c8f5c83124ce0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75c0abeeb9da657f303f2da8a6c5fa320842e662e14fe885447781505f1809dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88916d482c589f597f51569afec06b9dee6010e4e30c540490cc4091584201e1"
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
