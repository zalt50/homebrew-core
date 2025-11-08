class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.111.0.tgz"
  sha256 "767e0b2a91bcd352098a9e6711a8c74ed33840f747df2359691d01015e679eb4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "76d65af9fb3bb738486b8e1aef88058b8535608fcab0d4903962428e1efeab76"
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
