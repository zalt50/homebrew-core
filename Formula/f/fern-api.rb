class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.58.0.tgz"
  sha256 "5a043dc2757b8acffef2ffd7d9fe3ed477484e3640009909621f1d598fa83fa2"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f864a143b8026d2920befd774742cf8d3e9fe75878ab6f65167bcec5953850f4"
    sha256 cellar: :any,                 arm64_sequoia: "fc734d56cf7b9da862594eacf4c3885492874e9e32e11d1d5a7fa4efc6d0362a"
    sha256 cellar: :any,                 arm64_sonoma:  "fc734d56cf7b9da862594eacf4c3885492874e9e32e11d1d5a7fa4efc6d0362a"
    sha256 cellar: :any,                 sonoma:        "b708ed1e54d44eaaf8d0d7edd7b585f79a2e966cf6cb1b435dcefe17d0137ab5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02b027ad3fa1683a6aef160aa94283c61e58e2f0a614eb9ceae521a226c48565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ebf91d37e3cca228f2b6bd81798d941857c71aafeaae033c020bda3e4bc3040"
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
