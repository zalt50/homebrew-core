class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.117.0.tgz"
  sha256 "b6c73d011e58b906cf8bf04364de328d0d5165b4aa176ff5f901d50a51525934"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ddeef5b720c6e8c92c19025ef1f16e32078d972e2498cb5ccee50ab76611745"
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
