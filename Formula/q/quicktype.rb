class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://app.quicktype.io"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.3.12.tgz"
  sha256 "bd6822c9ef996bfa78d6876f81b3d00d35375d32279bc988b2ec38c98e70e45f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "25d449bfe5389d189ce6edd0f69ba7b7572aba4e9959ce78b6b09310978d7815"
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
