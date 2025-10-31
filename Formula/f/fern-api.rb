class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.102.0.tgz"
  sha256 "b599fc1ab79d4e9ab2b9b8564585446611c6faa741b5b0fc4453a6207f99241f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "81d1d815b0842dd61e3bd0c97dbe6b606a8082693739229e1c0c8278ef020fba"
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
