class Soar < Formula
  desc "Fast, modern package manager for Static Binaries, Portable Formats and more"
  homepage "https://soar.qaidvoid.dev"
  url "https://github.com/pkgforge/soar/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "6544821a1cea17397cff1db5cbde5ff45bfd92770c18a22ce2d7421e4aec1684"
  license "MIT"
  head "https://github.com/pkgforge/soar.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_linux:  "fa42add6529c20f0a9cca71e079074a736c00a11d5b915938a06e8241bbbb9d8"
    sha256 cellar: :any, x86_64_linux: "6aa0e54afeaf27a996cc116ba4dbe96045d9bc48cdaa6998269a925fc2b6d1c9"
  end

  depends_on "rust" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/soar-cli")
  end

  test do
    system bin/"soar", "defconfig", "-c", "test.toml"
    assert_match 'default_profile = "default"', (testpath/"test.toml").read
  end
end
