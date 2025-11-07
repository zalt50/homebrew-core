class Bulletty < Formula
  desc "Pretty feed reader (ATOM/RSS) that stores articles in Markdown files"
  homepage "https://bulletty.croci.dev/"
  url "https://github.com/CrociDB/bulletty/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "855aa55629ca0846b1b50a87f2c18c2b7f76d8aa0fbd276187b70a5cb3bc34da"
  license "MIT"
  head "https://github.com/CrociDB/bulletty.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bulletty --version")
    assert_match "Feeds Registered", shell_output("#{bin}/bulletty list")
  end
end
