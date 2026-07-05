class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://app.quicktype.io"
  url "https://registry.npmjs.org/quicktype/-/quicktype-23.3.1.tgz"
  sha256 "b1f024d8c3b4cbdf2348adccec2def764f6d95a50f677ff2164c89ea54bcd39c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a6538df95ea98ba99af6aef74fb0e9e380d37cf83b251dbda869f286bd22b7c"
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
