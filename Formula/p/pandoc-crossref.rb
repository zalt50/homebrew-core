class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://lierdakil.github.io/pandoc-crossref/"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.25.tar.gz"
  sha256 "cb42b8319a59f258fea191e4660b62bdd9a90a9099322ae0f17203bc5986498a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ad790a96e2e516323595c1ec40f98af37c25bc1e03869de142df4906cab08f38"
    sha256 cellar: :any, arm64_sequoia: "04bc15079465d3e8ed69eb0d9ad5861e3478c1bf3a97e730be6989e77ccbfaea"
    sha256 cellar: :any, arm64_sonoma:  "b06df185e160de796f91b733366b45dd671c28be108cbd60ffa17ab5a86fc3e8"
    sha256 cellar: :any, sonoma:        "13546d12be2f5064fdeaf2d2a11fb5562b6b283690b196fc40b17344388d2bef"
    sha256 cellar: :any, arm64_linux:   "e9b8950ef7e484211207357e582bc6842dd8872719ed4db079d1abdf2fdc0bb2"
    sha256 cellar: :any, x86_64_linux:  "5537484b5e14e8c3369bbb52e8b43bccd56903b836a1efb7d33977a39992b0af"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"
  depends_on "pandoc"

  uses_from_macos "unzip" => :build
  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    rm("cabal.project.freeze")

    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~MARKDOWN
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    MARKDOWN
    output = shell_output("#{Formula["pandoc"].bin}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end
