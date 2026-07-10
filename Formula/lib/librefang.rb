class Librefang < Formula
  desc "Self-hostable operating system for autonomous AI agents"
  homepage "https://librefang.ai"
  url "https://github.com/librefang/librefang/archive/refs/tags/v2026.7.10.tar.gz"
  sha256 "15c1b4f527b8989ba7d7f3624edc3ad15fed5d5db18793d99ee9ed27901491d0"
  license "MIT"
  head "https://github.com/librefang/librefang.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f69350832f4c13083cf120e60e1386cbd1d22d14ec3f734f0184588998032aab"
    sha256 cellar: :any, arm64_sequoia: "93db17e9cae4a48e811e22126b65687af2ba5f098b0b6c5079239b2004218b4b"
    sha256 cellar: :any, arm64_sonoma:  "cb3f5b5417aaf9b37db3561e14b68e5a13303d3790b80533abbef57650a8ff85"
    sha256 cellar: :any, sonoma:        "c870dc7d68d66d1afa59fc95bf6d569117a454364991e92efa7c1347f13a1ca8"
    sha256 cellar: :any, arm64_linux:   "f39875a8a7c58a04a16ce86950c4f5b79dff8e63afe8ed56db6170f1e4c88d18"
    sha256 cellar: :any, x86_64_linux:  "79fcbd25c2c98063e4488d6cc12c6010c7c128d53a7164fee96db5953ecc7df8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/librefang-cli")
  end

  test do
    system bin/"librefang", "init", "--quick"
    assert_path_exists testpath/".librefang/config.toml"
  end
end
