class Shiki < Formula
  desc "Beautiful yet powerful syntax highlighter"
  homepage "https://shiki.style/"
  url "https://registry.npmjs.org/@shikijs/cli/-/cli-4.4.1.tgz"
  sha256 "3176fffe1c9acbdd1edc48fdfe379d4976e287a90957e898d0b5511599229fba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bb584f1c34afd786537afb7b642abe5b5b6d479332b41d7eecdcf9adf812342e"
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
