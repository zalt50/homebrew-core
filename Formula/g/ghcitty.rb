class Ghcitty < Formula
  desc "Fast, friendly GHCi"
  homepage "https://github.com/mattlianje/ghcitty"
  url "https://github.com/mattlianje/ghcitty/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "d38c1c030351f18f4d35e6ccf2be2d8e9ba388501b5f4f6de8b7f2574a254c58"
  license "Apache-2.0"

  depends_on "rust" => :build
  depends_on "ghc" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghcitty --version")

    assert_match "[1, 4, 9]", shell_output("#{bin}/ghcitty eval \"map (^2) [1, 2, 3]\"")
  end
end
