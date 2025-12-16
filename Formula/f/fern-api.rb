class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.24.1.tgz"
  sha256 "9fd69072f712065f0e27c49942645719667982a8e57b6a39bc52c1825e47183a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "267802d627bf7bf9f7b6c9ee07d4b7864b1b7f1fc55eff8ecfaf0f8f10206fa7"
    sha256 cellar: :any,                 arm64_sequoia: "ac45eb2f074d9b704be9159d8b88ecfff4a7a596f59a9e64c6b3e0e0835522b7"
    sha256 cellar: :any,                 arm64_sonoma:  "ac45eb2f074d9b704be9159d8b88ecfff4a7a596f59a9e64c6b3e0e0835522b7"
    sha256 cellar: :any,                 sonoma:        "88a6dae1aff5ef840e2c4615bd38f5d918fa4f9b5d0562158d3039c19b2f341f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ab205135598718015b2af54c6076d7d2ede189acd5ea12b6d3804a079e20639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fda980210c93970a28e46c333b07aec7bf44b6ecaa2e875b2f3f3490c0624b75"
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
