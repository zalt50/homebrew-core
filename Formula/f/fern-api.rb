class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.3.0.tgz"
  sha256 "cc8a26662dd6b144ad1fb03cd2bcfde6189a460933ba11ba53bdad96e7db7037"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "47186421cdc247ec39991ba1c907c420cd95920289c3e33aa1f4a59b3c9d5c86"
    sha256 cellar: :any,                 arm64_sequoia: "03ab24e2028893bdf61f21ac80c8b1335fe8f9729abdbee73f6381ccf5b00411"
    sha256 cellar: :any,                 arm64_sonoma:  "03ab24e2028893bdf61f21ac80c8b1335fe8f9729abdbee73f6381ccf5b00411"
    sha256 cellar: :any,                 sonoma:        "7b86af7145002b51eeff256d56a197f5c47c86d0a4b54966450a310ea02e854e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bed0cdce981e0476d620b19e2737a9cffea92146d04a7e933dd7b28f83b33163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f4eeff30660532660ac5621b8f4692cf36df71267e161278f4e57dcafd38033"
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
