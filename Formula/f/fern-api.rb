class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.185.0.tgz"
  sha256 "c5d8053be2eb2736a5a722b6f95559f75b5021336e364a06b789612ba5809ee6"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "6acfca964c25d6c390cf0e96d3664ae07a069e6e24253c16c7bdd50ffc1ae40b"
    sha256 cellar: :any,                 arm64_tahoe:       "6acfca964c25d6c390cf0e96d3664ae07a069e6e24253c16c7bdd50ffc1ae40b"
    sha256 cellar: :any,                 arm64_sequoia:     "6acfca964c25d6c390cf0e96d3664ae07a069e6e24253c16c7bdd50ffc1ae40b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cf52dc94383921a571c60ee4e90fd51035910b49859fe3c9ec3a8c88bba51b1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "645ae9edb5728ab093f598ed1a23fdc2adac8d49133902b632e2b39854db0dfb"
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
