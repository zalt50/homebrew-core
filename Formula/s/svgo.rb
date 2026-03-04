class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://svgo.dev/"
  url "https://github.com/svg/svgo/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "2eae41c56d069a1943c58f0141eb5c747c968e6db7c67dae5f529c01103b5b5d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ec0f78a0a81069dcd687212bb5afc0a980197b1f762d35a47ec58f4c2a416473"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    cp test_fixtures("test.svg"), testpath
    system bin/"svgo", "test.svg", "-o", "test.min.svg"
    assert_match(/^<svg /, (testpath/"test.min.svg").read)
  end
end
