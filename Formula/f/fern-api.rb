class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.86.0.tgz"
  sha256 "bf562f3756fc3f72abc43a8311dcdada01c352d1317f54da73edcb0b1cb2bfbc"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0185b4d2ccac9853018c05c6be12a92f452cf2b7deb9f4377d02952576f80337"
    sha256 cellar: :any,                 arm64_sequoia: "0185b4d2ccac9853018c05c6be12a92f452cf2b7deb9f4377d02952576f80337"
    sha256 cellar: :any,                 arm64_sonoma:  "0185b4d2ccac9853018c05c6be12a92f452cf2b7deb9f4377d02952576f80337"
    sha256 cellar: :any,                 sonoma:        "240ef594b0755efcfd351d10f93ff3f29b401b741b59bc00d2f48d56c1f50382"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae2a1466a16061894b99e17dcd07496051ec8faa9510af46c23c92dcdf952369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0176e6859dae0ea36c253215236c96f68c83b3502d9ba5a20a20da8af674f02f"
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
