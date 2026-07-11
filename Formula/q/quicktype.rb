class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://app.quicktype.io"
  url "https://registry.npmjs.org/quicktype/-/quicktype-24.0.0.tgz"
  sha256 "4a3c85ac1dc5d99d2ce1188468c7d8ac655fd1d359a81f433c46af7eee33e2b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dcdc302d20e46c66456ae60c5a0bdba463b6a490c3377b809035e7ddec93754c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"sample.json").write <<~JSON
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    JSON
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
