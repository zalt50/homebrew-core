class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.101.7.tgz"
  sha256 "1f1a881eb9b9e2be1eee501d08d500e4b0fbda071b52f4d21e8c4758d1f8bb9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "505898048086dd357e25548b57e7fc677dd4f71ee4c1ebf31074a73340e38b08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "505898048086dd357e25548b57e7fc677dd4f71ee4c1ebf31074a73340e38b08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "505898048086dd357e25548b57e7fc677dd4f71ee4c1ebf31074a73340e38b08"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec0e6c62968ffa6cc8e2689f5525e726abe1085c8d992e0ce694d3d39680bb13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54a01170365873ef906e30132995fc064f1ca3ab6c764be2a3ef41c2531d3dbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41f3d36a2bf599f6561ec8a5b891aadca0864d16f0705d5ebf6467ea99660060"
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
