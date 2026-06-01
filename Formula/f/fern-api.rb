class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.44.0.tgz"
  sha256 "8b9fad6def569482b72744c81f424b3966f4b7f28c3f21485ac0e2133549f61c"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1f49190ae056b0409b8740701e5931e56030c60cdc338e895ea36b1e57a81939"
    sha256 cellar: :any,                 arm64_sequoia: "7d37f4185a730691ecb9ccd2077a962fdd8fc25f0c63663f8745a53d4b4b4717"
    sha256 cellar: :any,                 arm64_sonoma:  "7d37f4185a730691ecb9ccd2077a962fdd8fc25f0c63663f8745a53d4b4b4717"
    sha256 cellar: :any,                 sonoma:        "6e5ee4a811aadc935f20b0c9696227aaf87f1d1ef86be416a24127569131ba02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "633234418bf7233c0b9c24c1c8be4c7d2513006ce3dbef4cd62a853f8bd1dcd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc2f92ddcaa6567f53730574de3489bb7511f0190a5bfea968da5f3e42e68ce7"
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
