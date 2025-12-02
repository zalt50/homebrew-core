class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-2.15.2.tgz"
  sha256 "b7f7e17d5fc85d9ae53b61ba55ded54d5689010e3989de0deb820130be821aa7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f76850e44da9dde497fdd207621a75b5a160d31cf96da067dc4374aaa70dd56e"
    sha256 cellar: :any,                 arm64_sequoia: "07d96d6217c98cb1cb260bd7586b9e4d74ada492eb325934d6d9471bac6d49d6"
    sha256 cellar: :any,                 arm64_sonoma:  "07d96d6217c98cb1cb260bd7586b9e4d74ada492eb325934d6d9471bac6d49d6"
    sha256 cellar: :any,                 sonoma:        "af4ebeec3e496b311ed6518bd5a56be628660b54310ad9b711eb61b6a982b96a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0ccf741ee8fde5f279c24b650a2f3241fe43df69f6a9de2f842777be68f19d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0391f8117b5525eec0ff4c498b536ff1f2e33b6ecc701e53415ca3520a9ff462"
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
