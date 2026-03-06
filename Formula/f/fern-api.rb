class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.9.0.tgz"
  sha256 "c51918c764ca3f0d96e975092dd508fba53f0e062d258b57c1dcb456c0aa9091"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bdaddfabcfeff298169fd2c60d0fed7088cd09058a7e9ea481a5a30e633afdea"
    sha256 cellar: :any,                 arm64_sequoia: "e7f108b194b3a7c84a8cf4a7a43d769e4c5dcb365227dd7a4b4545393ec5d341"
    sha256 cellar: :any,                 arm64_sonoma:  "e7f108b194b3a7c84a8cf4a7a43d769e4c5dcb365227dd7a4b4545393ec5d341"
    sha256 cellar: :any,                 sonoma:        "3470e610c6f229846e9a3868b155acbd82f0b1aa32bde42f6f5d46a18e58c8e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1856ed4832d7faff6f4c4440798e6a9ce23221189a6f470ffb1500c57c17aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc301ad7fe8dc4fe7ce0aab8d1f615d956c82500bd6682c6013c87cad726d394"
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
