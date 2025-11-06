class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.109.0.tgz"
  sha256 "8c623d6c6ae4fbc825445139dffa4941e33490a4357f63588a2703ab07f5850d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "62c59106140ed5593dc20be35a634bd9a7d3545ebffe06f2f5debc705bab06ed"
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
