class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://app.quicktype.io"
  url "https://registry.npmjs.org/quicktype/-/quicktype-24.0.2.tgz"
  sha256 "2843cb0e70033cf1fd4eb3439aca0e6f0ab41ced97536d638b3295697728e65f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6b35d53518010f22196bd5db3b15ecd57f818076b13c19467998def16566bb89"
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
