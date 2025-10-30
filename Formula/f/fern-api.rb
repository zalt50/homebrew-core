class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.100.1.tgz"
  sha256 "da1daa006289d1bafb0ba7510ff1d628f9e1edeb8bc9036b182fd50f1fba9b61"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d30521d5c029d57d08680383a4e4ad724f6dca99f0ea2abe75b1422e32222cee"
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
