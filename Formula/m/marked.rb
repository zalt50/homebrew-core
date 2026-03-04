class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-17.0.4.tgz"
  sha256 "651ab10bab456da22585aca676075c9cefcfd8e65aca64a94a33d5bdd3054ce9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aa238ccf16c74ee580c9e01ea4517cebcd840f7436bf7a6641e2c80aa9184294"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output(bin/"marked", "hello *world*").strip
  end
end
