class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://app.quicktype.io"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.3.22.tgz"
  sha256 "be157311f93b295f26c3f7d2da459dc3d55b1cf7ffd75a13cca917566b95b136"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f33b16ab4ab794805a16ac616bc88f474139271e88ab1d279949bbc5985ce3cc"
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
