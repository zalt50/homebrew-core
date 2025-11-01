class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.103.0.tgz"
  sha256 "3425251e11a5e1e9f940fa9c47020d8bcb68db12a0a36700eae4428ebcc4911f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6ccdc42c48f7e8ad130f2f2c430e051b02377bbc3c4bd2a556157790677060fb"
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
