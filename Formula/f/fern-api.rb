class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.87.0.tgz"
  sha256 "d6d66ff0300b75650f7d7064b66c6b067d39b91295a87d9026d2539f097f11b8"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ff5755def4caf8fb9a2d47532a25537fec7b9259e142de562e7b7d1c632ac433"
    sha256 cellar: :any,                 arm64_sequoia: "ff5755def4caf8fb9a2d47532a25537fec7b9259e142de562e7b7d1c632ac433"
    sha256 cellar: :any,                 arm64_sonoma:  "ff5755def4caf8fb9a2d47532a25537fec7b9259e142de562e7b7d1c632ac433"
    sha256 cellar: :any,                 sonoma:        "81523395cf6d3a10af3809b22a53ced5219ca36fadb2a9c63c6bef01ed2bdc1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89d96accc2a23f9fb63ac11bfe96e9756e295c8f6ff4412ba2ef206c24d496c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdd73fd4858b01478fc1ff1165e3b8e7ef37c6389a0c904f3fc7b18b8097abe3"
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
