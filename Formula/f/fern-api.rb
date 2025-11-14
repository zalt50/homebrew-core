class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-1.0.5.tgz"
  sha256 "337bd7e87098d2f0192f9756897a3987fe29526c581c9abbb32b52e4b049f439"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5bc59c9db682a71356f974697434578608d2d8fe6697c18375b1ce1641a20dd0"
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
