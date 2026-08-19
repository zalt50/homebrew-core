class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.0.10.tgz"
  sha256 "546671792633e2770cc4b8e2a6037b5c523e8d18c5b6750c813281a9bb429ddf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "81e117fc37731b2ad08928deb070e036cf17b956aad516b2d535a44daa503d12"
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
