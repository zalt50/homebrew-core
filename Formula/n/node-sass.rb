class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.101.3.tgz"
  sha256 "3880ee9c7e58872ec987f258c2cfceb1ac8a4220522669b2a3ca9e9ff6910e88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "556e5f31ff3dbd9e151373be174a45e03da31358c379a129cbd53978eb11f08b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "556e5f31ff3dbd9e151373be174a45e03da31358c379a129cbd53978eb11f08b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "556e5f31ff3dbd9e151373be174a45e03da31358c379a129cbd53978eb11f08b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9351d3091c60e253f7bb2097e5647b19b0eb360ebdd50adff76c58a6bf2425f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8c9a1925bc7cd4bc5922bcf077215da985228d1dcd21d3a5cc120dc0d80e57b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c79cad9391656bdecefdecf28f1ef3c0a972d2b721aa07265902f411da81eed7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.scss").write <<~SCSS
      div {
        img {
          border: 0px;
        }
      }
    SCSS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
