class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.99.3.tgz"
  sha256 "79cac6bf9494d11f78c8163afb8175d894efe36d7a3cbc79bf748c12cc2129f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "66534bc25f39e3e3bfef802401951d8cc089c35a9db8047a8b9694ed0683c797"
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
