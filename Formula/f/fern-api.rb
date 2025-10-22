class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.93.4.tgz"
  sha256 "a2ed7d34c9e8d48f25c36cb2cf33a3f60d2e8721ab4d14109dfcfb87120bb534"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a07e4b509a9a984cd7a6fae6e6da3870b7419b6fe1b7c8416ba3d7ee38c396f3"
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
