class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.94.5.tgz"
  sha256 "825d5fcfe61c55e265ded67cceb89eb57ecd3dd9e10bd9c87d2ff0f6fc0d7023"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6865596e855d40ee2f99de2c16297b080843ee22952df2a4b7f6cfd632e02036"
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
