class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.84.0.tgz"
  sha256 "87dc4cda10fd056b3d4a78aefc21c402de1b32475b80b63fa18bbf0854841cf8"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "263c6da5433b6d4cb95d28583ba73aa2f7760582eeadfd85e3c7a1ea36529943"
    sha256 cellar: :any,                 arm64_sequoia: "263c6da5433b6d4cb95d28583ba73aa2f7760582eeadfd85e3c7a1ea36529943"
    sha256 cellar: :any,                 arm64_sonoma:  "263c6da5433b6d4cb95d28583ba73aa2f7760582eeadfd85e3c7a1ea36529943"
    sha256 cellar: :any,                 sonoma:        "7e1806b501a1c2dcb05f5b31c7a9e359df66b502e08dd43e655c5182c66db20e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4883a4d32d358b9313fd477ce87d61b3226740e89bde1c33f5b892d842eaa96c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c7dde45a2bd0b751a81af3a31e8cf9587c6a9026d344343b9a559dad330988f"
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
