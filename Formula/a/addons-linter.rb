class AddonsLinter < Formula
  desc "Firefox Add-ons linter, written in JavaScript"
  homepage "https://github.com/mozilla/addons-linter"
  url "https://registry.npmjs.org/addons-linter/-/addons-linter-9.4.0.tgz"
  sha256 "9b63ad0a25c4967fd1ee9f4c18b38f4a42b5d30e3f50cacda6230f34c7be4a45"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d03b4e0a693d136e25575390976b12867dfa9ea73f4b116143e099a1911d5dc4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/addons-linter --version")

    (testpath/"manifest.json").write <<~JSON
      {
        "manifest_version": 2,
        "name": "Test Addon",
        "version": "1.0",
        "description": "A test addon",
        "applications": {
          "gecko": {
            "id": "test-addon@example.com"
          }
        }
      }
    JSON
    output = shell_output("#{bin}/addons-linter #{testpath}/manifest.json 2>&1")
    assert_match "BAD_ZIPFILE   Corrupt ZIP", output
  end
end
