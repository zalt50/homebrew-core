class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://app.quicktype.io"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.3.6.tgz"
  sha256 "c953ab651025b829b471bb3ccd2471a76cecab1b9cf71553c3889207409a963b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6db550a31e89595fb68f87e63e9346c7c46e7850046b133b95e9b653c6fe4010"
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
