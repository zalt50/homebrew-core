class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.52.0.tgz"
  sha256 "896fe123a9ae3a6624408bdf26c7230aff36c497c0a9fe8b50554b01fc177b19"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ae6e1ac4645a30497f6fd8d931d547f68286fa674dc2ba0ed290fb2e5090a9f1"
    sha256 cellar: :any,                 arm64_sequoia: "a971ab8994f015fd0b6f22cf571c57ea40a854bc1b311161a63262e46a54a066"
    sha256 cellar: :any,                 arm64_sonoma:  "a971ab8994f015fd0b6f22cf571c57ea40a854bc1b311161a63262e46a54a066"
    sha256 cellar: :any,                 sonoma:        "514c1b2e2530c34d4e13dc69e67823205f908ae3429e243c2771ca8d0c421aaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af655bf5df9cd19e063a63a0628158660bb58e3a99ee5e76941b1293090e4b26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55f6c07f3d07d3a28c0ba1073385a6c13ac0b0aaa3d4284e864dc6137131aae8"
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
