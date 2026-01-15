class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.42.3.tgz"
  sha256 "092e00f8672f01c847aed990a0c1f18570b42c51154bcae61c1036963b96ebc0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "48c5d6075dd7bbfe88a62ee0e364b7621ad503e4395e7c1523a1e9e49f449fe0"
    sha256 cellar: :any,                 arm64_sequoia: "c111004d459191bfc56ccb2b4e254a38e53e95c053213816a44b8a6847a422df"
    sha256 cellar: :any,                 arm64_sonoma:  "c111004d459191bfc56ccb2b4e254a38e53e95c053213816a44b8a6847a422df"
    sha256 cellar: :any,                 sonoma:        "c405567fb52f4145e32c38d2c637d088939478fd8ea2773bc4164a3a0c32d91e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a996d465ac16c100dd2bce9052e355319f877904f2f80318e64cf2798a0dc70b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "330503fc1b610d70000e080ca8593e494c6ab48eda457f76d6cb1c2e91699e09"
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
