class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.132.0.tgz"
  sha256 "48bea3fd8e1f0166b24c453b51f1cf5c538022f50e7a1cc29a39f37e27f8b1e4"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "ea40e9baa75f34ec41880a8b93f3e5b0bfaa04ebf18ec701cdf17b36f9738f0e"
    sha256 cellar: :any,                 arm64_tahoe:       "ea40e9baa75f34ec41880a8b93f3e5b0bfaa04ebf18ec701cdf17b36f9738f0e"
    sha256 cellar: :any,                 arm64_sequoia:     "ea40e9baa75f34ec41880a8b93f3e5b0bfaa04ebf18ec701cdf17b36f9738f0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b7872dc1f40d27495179284394a75468d3c8fde9b6b357d5f02a6dd03f837ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f66e5e2c497c914cf9f28c5a9c4bfc2189dfbf778777603d3da90ad29a685fd4"
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
