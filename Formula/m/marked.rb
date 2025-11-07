class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-17.0.0.tgz"
  sha256 "c69931ee3765bfc8ce62d8d3fe1b54a2d4c823a6eda9f3c5937fd0da2e7594ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6ab6322e1b78f2875ded69929d615fb4e9709a11b806ad97fd0ef081da4c0623"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output(bin/"marked", "hello *world*").strip
  end
end
