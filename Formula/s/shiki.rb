class Shiki < Formula
  desc "Beautiful yet powerful syntax highlighter"
  homepage "https://shiki.style/"
  url "https://registry.npmjs.org/@shikijs/cli/-/cli-4.4.2.tgz"
  sha256 "a2125f25e88fdb304ed0ebdba08b7821dfbfcf2ed36fd794284774f2d0e5a053"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b87b6fe248277a9d56e53f39604c870799a2ed686b99b5fc29e030ff8955ec5d"
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
