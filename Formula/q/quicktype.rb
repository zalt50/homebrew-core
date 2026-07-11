class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://app.quicktype.io"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.3.25.tgz"
  sha256 "eb611509631623621724449076f66510608851aa1c8eeb9c8a1ffa127c25737e"
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
