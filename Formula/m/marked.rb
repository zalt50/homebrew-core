class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.0.9.tgz"
  sha256 "3017275f02c3bb33d668a892566f47c129da751292f29cfcaf45bded787d0dc6"
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
