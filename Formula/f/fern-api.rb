class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.96.0.tgz"
  sha256 "556c28be75478576b2c333d0ad03bd4bd26fd01509e7a7e8f7d7e88dfeff4009"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1924b4e0bfee1694cdc448b81e237773de709947b0f01974b55c356acd61530a"
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
