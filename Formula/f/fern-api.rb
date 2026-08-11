class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.93.0.tgz"
  sha256 "33817d3a7bc011c3d9a0fd4519a4d836ade1399f6d1ddb61b103c1bba44517b3"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f503a44cdc4516123e001468af3275d1d7eec6c8f961e6d9622203bee9d415f"
    sha256 cellar: :any,                 arm64_sequoia: "2f503a44cdc4516123e001468af3275d1d7eec6c8f961e6d9622203bee9d415f"
    sha256 cellar: :any,                 arm64_sonoma:  "2f503a44cdc4516123e001468af3275d1d7eec6c8f961e6d9622203bee9d415f"
    sha256 cellar: :any,                 sonoma:        "2b5ca65f8793e2c6e8cd9107431177bf6cfd84f3c3445d7a64548e92ceb8e31a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be71553b68e5d174347fd22a167fe179699149bea1518b8ac4fec6735b6d12cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8af4aa99ef9e82f9dd4662b29220bbb367248c3da2ff40f03a82a2e19e99d7dc"
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
