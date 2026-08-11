class Shiki < Formula
  desc "Beautiful yet powerful syntax highlighter"
  homepage "https://shiki.style/"
  url "https://registry.npmjs.org/@shikijs/cli/-/cli-4.4.3.tgz"
  sha256 "26ba2accb28a6d226359757611540171fcacdd48bfac1eee67cdbd6d8fbef776"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f7ee64f239db51f77a8699dbafb12fd17924bdae9dac2ee1a0adc1f838c2ab87"
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
