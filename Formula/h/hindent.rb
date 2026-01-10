class Hindent < Formula
  desc "Haskell pretty printer"
  homepage "https://github.com/mihaimaruseac/hindent"
  url "https://github.com/mihaimaruseac/hindent/archive/refs/tags/v6.2.1.tar.gz"
  sha256 "9f3dcd310b5ef773600551af9eda8db40f69ffd570d8ed474f7b8c2e93cd55ec"
  license "BSD-3-Clause"
  head "https://github.com/mihaimaruseac/hindent.git", branch: "master"

  depends_on "cabal-install" => :build
  # TODO: switch to ghc@9.12 in the next release
  # https://github.com/mihaimaruseac/hindent/pull/1000
  # See GHC 9.14 issue: https://github.com/mihaimaruseac/hindent/issues/1155
  depends_on "ghc@9.10" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hindent --version")

    (testpath/"Input.hs").write <<~HASKELL
      example = case x of Just _ -> "Foo"
    HASKELL
    (testpath/"Expected.hs").write <<~HASKELL
      example =
        case x of
          Just _ -> "Foo"
    HASKELL

    assert_equal (testpath/"Expected.hs").read,
      pipe_output("#{bin}/hindent --indent-size 2", (testpath/"Input.hs").read, 0)
  end
end
