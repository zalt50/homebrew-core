class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.30.5.tgz"
  sha256 "a1fd4e60db502681727035b09ee5412d804c4bcf15f28f0a91c408ee7b852a25"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a1ddddad6d9719b665c7ee9f35f1f5ece8b87bcfb0797d8834d85348612aecc7"
    sha256 cellar: :any,                 arm64_sequoia: "c690242361ba4493596d13445bf7143a59e2273da044c1ade9a325aa60a9764d"
    sha256 cellar: :any,                 arm64_sonoma:  "c690242361ba4493596d13445bf7143a59e2273da044c1ade9a325aa60a9764d"
    sha256 cellar: :any,                 sonoma:        "398a694cb1428247abc8a275270445a39ace1c9de8dc67800dd12b81fd94dfb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b6eef0513f83d145312b19e6e2b603be0ad0de7a05929222572230b4a06e565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c211ba3d7f06fa3ca946428025704c4b055904d3a85a600f505bea79c7c4743"
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
