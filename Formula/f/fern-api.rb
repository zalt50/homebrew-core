class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.107.7.tgz"
  sha256 "a38c6af047407f352bf4a007761e04e04c5ca6e3a9366b79c87c1cba506b00d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3a7d1f3c5314306b217657bae4ba8ad741b1e9d0e70da17baea779975676c9ba"
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
