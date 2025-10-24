class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.94.5.tgz"
  sha256 "825d5fcfe61c55e265ded67cceb89eb57ecd3dd9e10bd9c87d2ff0f6fc0d7023"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "07c64a04a10634c36de8c043658f70b163f49bd7e3908250b2f2efd16a3ca1f3"
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
