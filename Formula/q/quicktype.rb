class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://app.quicktype.io"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.3.2.tgz"
  sha256 "c805b673898f00c84b06e197071d550f813f4e06d8b5d6f1b52a807cbe003904"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c409f2904e50e8d5d6f7b15b5f8394fea7de1a426bf206bb2bf5ba1433bd6a04"
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
