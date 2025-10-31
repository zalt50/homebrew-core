class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.101.3.tgz"
  sha256 "9acebef5cb0afd0a31dbe54505bfe4eec210733db439784f60d3cb769e54c074"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3c9c775ed5767fb583421d2c5d71defa4c2ffa51b3639159901b79389c7bed76"
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
