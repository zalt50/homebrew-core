class AddonsLinter < Formula
  desc "Firefox Add-ons linter, written in JavaScript"
  homepage "https://github.com/mozilla/addons-linter"
  url "https://registry.npmjs.org/addons-linter/-/addons-linter-9.0.0.tgz"
  sha256 "b9c82b796c84d22b9ea6ceb3833c4e5e97116b05cbd8d6450e6ff78f458d7e1b"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8c98b516f61e469d0e0bb606ee3feba6c810facff5bc01806bd8a9d6ac22b5fa"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
