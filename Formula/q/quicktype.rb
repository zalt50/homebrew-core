class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://app.quicktype.io"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.3.21.tgz"
  sha256 "9e61d2e05f0ebbe4ce52dea2ee3b700611ef24fb835e8b560b620ebb6cef5df7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cbc1e75195966f991f5edd0b88466287421a59f1ca573f8c3a724cd9bb5a645b"
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
