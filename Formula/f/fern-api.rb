class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.41.1.tgz"
  sha256 "3af20dbc10b6521b5eae6c910db5289266de6c0be22bb432283c0b848b8819d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6f63e86b3844fa0a3372349d68491958f2886348aafc00ff14edb0686f9b7275"
    sha256 cellar: :any,                 arm64_sequoia: "35b8c7325fc478cbbc115cf373031263fe2f9770ab1fa17818fe9d7c9a953ec2"
    sha256 cellar: :any,                 arm64_sonoma:  "35b8c7325fc478cbbc115cf373031263fe2f9770ab1fa17818fe9d7c9a953ec2"
    sha256 cellar: :any,                 sonoma:        "bdd55069eb7a006666e877e773ae5db4b7dce0921501ec29448972a934357b1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e220e8b9f54ad0dfcc40b04851acbad4266afd098cb7a98b94e084e7db274a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f78a4ff8410fa0edf119dde747d3919413df99bd67709af30c2cfd3c86d013c2"
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
