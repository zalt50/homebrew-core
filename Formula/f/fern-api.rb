class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-1.0.3.tgz"
  sha256 "a5b8fa4078d0d5bf94b51ebf0ec3d61a1034bea9c4e2ea8ea1419f789d729dda"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "208a02786d1233cab04b33de06f7f376ed03bc8f84cc124c94127ebffcf11383"
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
