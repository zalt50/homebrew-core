class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-1.11.0.tgz"
  sha256 "f44031388e68de0abf3c2c05ff3ecf3c7100227fa22f274aa69bddafc8193068"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f8bdd402187e00314afbe38fe782582d732e58e603e22d7ae126bf99376c0f51"
    sha256 cellar: :any,                 arm64_sequoia: "2c20d4cbdb32c6247823d47fcc7fb41a7f3a2b21b30e284e149a33ebecede993"
    sha256 cellar: :any,                 arm64_sonoma:  "2c20d4cbdb32c6247823d47fcc7fb41a7f3a2b21b30e284e149a33ebecede993"
    sha256 cellar: :any,                 sonoma:        "63fc8f76d8e0a314b3a63c96b62e32563a1ab8f29012a43cf8278e4dcffab9b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31e19234e75b6fef0cf566d840f4cfbfd64d6db6143d4f3f9d5fcea0ed1c0a10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a85b6a210cf35fd82ec2822de908cf52fbc22ce11e79fd138e68eb9db7a10e0"
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
