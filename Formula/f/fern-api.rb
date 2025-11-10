class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.113.1.tgz"
  sha256 "0ea2e20edef260dcb402416ed1613c4f5a48c128810604659a79cc71830a5901"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d8f182756dd4340bdf42faa3ad7396da6f7cfa9cd591668fdace97bb42456a35"
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
