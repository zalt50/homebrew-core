class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.37.3.tgz"
  sha256 "8dd2f8a41bb98dadfe9118f2fd17c648ee623594e8da2fb94d46c0a8e17cba52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f521f5f2786b5831ee5761583e975d39224ede278f4c6c7f129885f96c9a171d"
    sha256 cellar: :any,                 arm64_sequoia: "f58aab58d346a5e297d307aa3949fa0ead5d648a9de8a9d0f17929451e0875ae"
    sha256 cellar: :any,                 arm64_sonoma:  "f58aab58d346a5e297d307aa3949fa0ead5d648a9de8a9d0f17929451e0875ae"
    sha256 cellar: :any,                 sonoma:        "c447b11a01e3ac1ead4631b12f3f8545e9c05593fc5eef039a90d3bcb6681fd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41b1382ebb9897ce26bc4f63b3acb4425c29311e4d446d0134d9e4a239ae59fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "397bd56d98722925292fb9c3684879a550b520b9e8eccfe25c24b617e89c1f30"
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
