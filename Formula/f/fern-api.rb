class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.114.0.tgz"
  sha256 "59af8311ff44d99c43f23c859278bd0f042c5e5d07fd0fa38327995646c00c7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5e2cb4741fdcfa3833b553fef3373e995e7114d9f8a940d62e0322f5aee6dc49"
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
