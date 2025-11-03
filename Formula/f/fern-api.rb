class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.106.0.tgz"
  sha256 "70e3e83b5249c35cfa929ddc82a87e48cbf1ab213a474412d12e565fa406ea36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "05624288330558844a4b31f5371412ab281671a3a7d0d3a2dc3e99390d67104b"
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
