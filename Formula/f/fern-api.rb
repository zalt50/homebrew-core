class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.120.1.tgz"
  sha256 "6c71c4f9f7664eec9da7ecab877465be9f02ce7f53ba72dcbf6bd81cf4dfbac3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "50932187a4e87162dd63c47fa5d4c691a0a895ea45c2e5a3246ac613663b2308"
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
