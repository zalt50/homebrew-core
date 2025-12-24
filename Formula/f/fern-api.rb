class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.31.2.tgz"
  sha256 "59420e92dc03e34e669ce19a29e013dcf5197e50af819494d785e2d604814a7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c05049282c1280ef03f5bf86b24c756461283245ad009abc74939a6dcf32300b"
    sha256 cellar: :any,                 arm64_sequoia: "183313b6d62f2e024c671bb43d6afaf8196e7bc54ef8fa0bce44377293cf45f5"
    sha256 cellar: :any,                 arm64_sonoma:  "183313b6d62f2e024c671bb43d6afaf8196e7bc54ef8fa0bce44377293cf45f5"
    sha256 cellar: :any,                 sonoma:        "d2d8d65fde0e194233c1a666a1d2a360c4a20fea5f066c70da39198973df42d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5ad238ecb6b233c37d6edae15be3fb62c24a3b4f3ac24921f277215a116fd62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33cda63553253f1ced0bee290f17c1b09e3210b467a669249d72fd5ee325811a"
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
