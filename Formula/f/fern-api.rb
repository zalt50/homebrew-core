class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.112.1.tgz"
  sha256 "cfbc3e2530b10c64936d85be16ebfa8c42e8602f4f6223e2627b0a54d93fa131"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "53ea240d1f62d27666f2f0db49ceeb593f43fa1fb2cf8e9a889013c18bbac70f"
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
