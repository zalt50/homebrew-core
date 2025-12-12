class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.15.0.tgz"
  sha256 "6eb255351c4d0c5b75c1fd2c62fc52bd9c4e30b37ab046c0a6d71dc78af8849d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fc84f50fc63dd2beb3dc899ea150bb2441d60261a0fac14b3007c080730e2e05"
    sha256 cellar: :any,                 arm64_sequoia: "6f9e2bc27b512f17a890a69cd59bb695d03c1fd38daca3779dd0e626dfadae79"
    sha256 cellar: :any,                 arm64_sonoma:  "6f9e2bc27b512f17a890a69cd59bb695d03c1fd38daca3779dd0e626dfadae79"
    sha256 cellar: :any,                 sonoma:        "a515cb4399cb827af74dfd7419b1bcc49d2ca5a4bcd11b887132d98e7faac7e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3604ce2295dbd816bcddfcc7589fbe731d2d261d5f66475013b323e781c80d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "150b62300210d5c17ed692fc76721dc21ba92c4079319d9959ff82cbad04e93f"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs", "await this.nudgeUpgradeIfAvailable()", "await 0"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
