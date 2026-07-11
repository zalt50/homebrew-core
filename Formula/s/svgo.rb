class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://svgo.dev/"
  url "https://github.com/svg/svgo/archive/refs/tags/v4.0.2.tar.gz"
  sha256 "f83f6d0ab9c12b7773683b78c203c18e52aa7a8f3f0ea0cb59fbbacb4dbf21fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bc845de2142eee65c2d44293adeb63b606e12581570517b5845f44d252262a90"
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
