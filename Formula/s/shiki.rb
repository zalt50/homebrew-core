class Shiki < Formula
  desc "Beautiful yet powerful syntax highlighter"
  homepage "https://shiki.style/"
  url "https://registry.npmjs.org/@shikijs/cli/-/cli-4.3.1.tgz"
  sha256 "4b2fd145d6766dd9a8134ee944cf614958738b98e6d75e0dac12642c47fb567f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7f1d4b58a229cc199de2e1085d8deb532fbbaf4bd935d6c3f841e73661d44f6c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shiki --version")

    (testpath/"test.txt").write <<~TXT
      Hello, world!
    TXT

    assert_match "Hello, world!", shell_output("#{bin}/shiki #{testpath}/test.txt")
  end
end
