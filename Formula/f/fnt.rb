class Fnt < Formula
  desc "Apt for fonts, the missing font manager for macOS/linux"
  homepage "https://github.com/alexmyczko/fnt"
  url "https://github.com/alexmyczko/fnt/archive/refs/tags/1.9.1.tar.gz"
  sha256 "d3021cbed37ae39a58e8b18ed5bdc471a12660b12e368d91270b438e58df671f"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "5cf790744e15280ed2d5fa7114f0724e1a2ca96e3014ccecb8012c1ac1df964d"
  end

  depends_on "chafa"
  depends_on "lcdf-typetools"
  depends_on "xz"

  on_sonoma :or_older do
    depends_on "coreutils" # needs md5sum
  end

  def install
    bin.install "fnt"
    man1.install "fnt.1"
    zsh_completion.install "completions/_fnt"
  end

  test do
    assert_match "Available Fonts", shell_output("#{bin}/fnt info")
  end
end
