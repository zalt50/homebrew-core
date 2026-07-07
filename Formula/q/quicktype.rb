class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://app.quicktype.io"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.3.12.tgz"
  sha256 "bd6822c9ef996bfa78d6876f81b3d00d35375d32279bc988b2ec38c98e70e45f"
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
