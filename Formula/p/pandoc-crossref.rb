class PandocCrossref < Formula
  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://lierdakil.github.io/pandoc-crossref/"
  url "https://github.com/lierdakil/pandoc-crossref/archive/refs/tags/v0.3.26.tar.gz"
  sha256 "17c1ec465291d779e23c14bba23730d2de927c0ed35a8fd24c3ddd6e91463660"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5a609afd665dd410efee9f02f56492f9cf01b1e759f98c7e2c7415c0c6c27a1b"
    sha256 cellar: :any, arm64_tahoe:       "0cc712dd5947e619e19884d9122b63de67cbb246683de98a37cd8c8390fe10d8"
    sha256 cellar: :any, arm64_sequoia:     "3cb845d198d2b5bcbdd7de42fb5852bd268ac9cfbafb9a82dc2cb218fdbfc953"
    sha256 cellar: :any, arm64_linux:       "408cb50591b572a3cd83ba64fbd90935e08dafba71651274f1b0fb6ef1dac916"
    sha256 cellar: :any, x86_64_linux:      "3a4d7031b99556503d662c964d32e0ca4419e5fdb14fb39722d6a0ae8e661f89"
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

  # Relax the pandoc bound so the filter is compiled against pandoc 3.13
  patch do
    url "https://github.com/lierdakil/pandoc-crossref/commit/7a50183c42826957067c8c59c7df9bb58fe49246.patch?full_index=1"
    sha256 "5b4d1b710dc5c3dbb971eefe603d7ea9cbccfb86e6dc504041345100d640e7ad"
    type :backport
  end

  deny_network_access!

  # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
  def args = ["--allow-newer=base,containers,template-haskell"]

  def fetch
    rm("cabal.project.freeze")
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--only-download", *args, *std_cabal_v2_args
  end

  def install
    system "cabal", "v2-install", *args, *std_cabal_v2_args
  end

  test do
    (testpath/"hello.md").write <<~MARKDOWN
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    MARKDOWN
    output = shell_output("#{formula_opt_bin("pandoc")}/pandoc -F #{bin}/pandoc-crossref -o out.html hello.md 2>&1")
    assert_match "∑", (testpath/"out.html").read
    refute_match "WARNING: pandoc-crossref was compiled", output
  end
end
