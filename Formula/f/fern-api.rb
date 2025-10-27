class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.96.1.tgz"
  sha256 "f343c4647ab1d4c3b4330428105c7b68c62ded0d01c182d4fd21e91d5f391c06"
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
