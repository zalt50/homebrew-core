class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-18.0.5.tgz"
  sha256 "7d0ea56f8c29c0e6dec5665e62ad8089136819ca7028612e52301c2ba279dac2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "307171d3b8b03037f4654fa12e90aa0edaf772e83f2b64ffa46e041989faff05"
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
