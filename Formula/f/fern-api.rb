class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.88.0.tgz"
  sha256 "844d57ea3147d0c06309ec0c5c69146d3451a75dbcf285374551c244e50ff7b4"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2c7b4ac78ef4f18e7bf2526acab7d1cc267e5e57ff7d19288a60ae5da01ed80b"
    sha256 cellar: :any,                 arm64_sequoia: "2c7b4ac78ef4f18e7bf2526acab7d1cc267e5e57ff7d19288a60ae5da01ed80b"
    sha256 cellar: :any,                 arm64_sonoma:  "2c7b4ac78ef4f18e7bf2526acab7d1cc267e5e57ff7d19288a60ae5da01ed80b"
    sha256 cellar: :any,                 sonoma:        "480a879e283e06be1284922b6bffe2604c87362e425279348e903c4430d34746"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1695179e0bab1ef4a7af4ed80ee523a0c0bf0aa08a4b5218f71e0d61f777839f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a97d77ee0e5ff93175fcb2656e9fa4d1efc60c28944b7d373a9cbb4be9428112"
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
