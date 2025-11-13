class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.121.0.tgz"
  sha256 "7303de6f6a2912dcf21af108a1f76837af26e804c14158c03098d1232365de79"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7c59ebc7f4ca2e0dc2a3d70f8b3c21b21137dadf10aa447c14d8c6d490838f56"
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
