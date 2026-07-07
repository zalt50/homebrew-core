class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://app.quicktype.io"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.3.15.tgz"
  sha256 "7c427bb520388f8e0ecf385b1743fc85768d90a8ddc834df30a44b0ca8ebfdf5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "19e55762c2a812775e0e8d10f1232fcd50d61da5fbe6964dd26ec0d90f518f5b"
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
