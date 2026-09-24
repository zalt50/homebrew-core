class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.137.0.tgz"
  sha256 "974985ffc15ea0e1143ccf90151a37100a3831494f893689000c0338b6b5d2e5"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "58044b2a16f5107e63e50c0544fc8861de8b5cb583a0bc4abbf391fdebd38c55"
    sha256 cellar: :any,                 arm64_tahoe:       "58044b2a16f5107e63e50c0544fc8861de8b5cb583a0bc4abbf391fdebd38c55"
    sha256 cellar: :any,                 arm64_sequoia:     "58044b2a16f5107e63e50c0544fc8861de8b5cb583a0bc4abbf391fdebd38c55"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c7aadb080e4c8e7f444372c06d5df063e0b9816146fa296645e599f06d99f208"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "59b26d5baefc78d37ab81d4c9e26f9bdc49c62063efaed1c47666f2190e27d32"
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
