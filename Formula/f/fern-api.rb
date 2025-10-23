class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.94.2.tgz"
  sha256 "e50dc082f9a02f746e90501e9dd601a0b7a3b3b6c77610c16367199435a54c6a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fb6e4319ffd164f6d55660db08155759642cca8807c58aaed18dcf54cc3dce9c"
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
