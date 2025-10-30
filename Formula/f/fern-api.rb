class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.100.1.tgz"
  sha256 "da1daa006289d1bafb0ba7510ff1d628f9e1edeb8bc9036b182fd50f1fba9b61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "713133eb85e7407a366404210474af2b5688f445b9fd92006c97d860d7025506"
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
