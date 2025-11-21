class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.26.0.tgz"
  sha256 "af645af97bb17e2507c6cfa8e482e5e2698943e9e3da0191f291b1817624ec53"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "12e574fea6001e7e95220f072e66d35d6503bc2f48ee32e40e46ffef2d5c3de1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".stylelintrc").write <<~JSON
      {
        "rules": {
          "block-no-empty": true
        }
      }
    JSON

    (testpath/"test.css").write <<~CSS
      a {
      }
    CSS

    output = shell_output("#{bin}/stylelint test.css 2>&1", 2)
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end
