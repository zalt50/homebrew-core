class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.35.0.tgz"
  sha256 "9720efa644df38fc3943ef48381a1688520e39ec562d4ebd022a12b5b63f2327"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a9216411ca2762d8bdd605825055c6e813ad916caaa1a6fbe11d6848c363d757"
    sha256 cellar: :any,                 arm64_sequoia: "5431ccf31d600e3d73425c34abc6cd5c596dee24e6e8f0d8bce6ce6cbc8f488c"
    sha256 cellar: :any,                 arm64_sonoma:  "5431ccf31d600e3d73425c34abc6cd5c596dee24e6e8f0d8bce6ce6cbc8f488c"
    sha256 cellar: :any,                 sonoma:        "8271fe8cc461768f2ec67ec70736e645a2b220c2ffe1c47e8be656440492e9b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "453ce296f3445cec6561dd508d86ab67ce107e336dec92b608c1778e67c15c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03e04a26d7b6d1d224c817ac96de7446793d2479bc2defb168639814468d8536"
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
