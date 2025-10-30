class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.101.0.tgz"
  sha256 "97da1325d6c6b7bc535ae6ab3501a920cfa5f7b855dfc4a11d9222e4dd6893d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "492fbf8401df3ece6f81e79618f26a96a848d2a77a03b3294ae43f38e5b7b9f1"
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
