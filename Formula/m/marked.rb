class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.0.8.tgz"
  sha256 "a0d2b16c7c84b9c3eaea8126c47b2bfe69a6099ada0a63990a3034e39777852b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "12b406ee3174ed430a3aef009fc9c94d33ef805dd175b968bcefa6153e957e04"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", shell_output("#{bin}/marked -s 'hello *world*'").strip
  end
end
