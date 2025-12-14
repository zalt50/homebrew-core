class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.18.4.tgz"
  sha256 "55d020ddcbd4a762e465016ad056ec5c7058a07a449091dc2175032e06efc9bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee707212a5239030d50606a3c80430fb6a96b044b1c6094cd615a062890ce065"
    sha256 cellar: :any,                 arm64_sequoia: "378420742129e02484cd3202ba8a5d8729ce89cdd2f08add40e1e78cc8831963"
    sha256 cellar: :any,                 arm64_sonoma:  "378420742129e02484cd3202ba8a5d8729ce89cdd2f08add40e1e78cc8831963"
    sha256 cellar: :any,                 sonoma:        "d59c5820f44f4a46c47fa2e6d5ef4a1953e9d0b3077fd0d68f5656cf24188932"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2de5c3d5ecf556bdcfe0f9a3906d4af9826b3e7d3ab2afb64857ee2172da4984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ed27ec0cc7bec7b6de8849369a19fc83975b02a9ba7cc4b25950d3ac57841db"
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
