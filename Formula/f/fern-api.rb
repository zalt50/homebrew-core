class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-1.0.2.tgz"
  sha256 "39d7c155dd4344d4b7f3e0c90768d134587bbe6b042a101c3186b3e915c0f432"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "917ab0f0a7f217977719b45cf27496e48c9044695d89e0d0153913c4e8bf7173"
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
