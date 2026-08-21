class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.103.0.tgz"
  sha256 "aa41b084177163ccd87a524ce810bee0e3e26b2d87980f3f0c489d9c3e7ed3b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e602c302fd7ea0021bb5820946cb3b2413bf0b9e97c09e49af91c6f227ac8799"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e602c302fd7ea0021bb5820946cb3b2413bf0b9e97c09e49af91c6f227ac8799"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e602c302fd7ea0021bb5820946cb3b2413bf0b9e97c09e49af91c6f227ac8799"
    sha256 cellar: :any_skip_relocation, sonoma:        "e18510a4292f751851461906c756c60812a3db289bd969a5abee5b49d4b20e69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cc4b04255fb1ddf7a7821bf5cb92378f63a9d736b9b77a9eb19cef8b422c234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c0d60f4a5841651d52ee9317b0764db949fc845d6bc5376d6a87aded83484ae"
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
