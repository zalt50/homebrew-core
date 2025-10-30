class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.101.2.tgz"
  sha256 "8baa1279d09eabfbfb522da0f8c10be8d902b0ae830f0617911aa94895a7b466"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "75426eb7b9b1a6e48d5079221a85f8916577349c5b14c0c26b1964d1e29aed64"
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
