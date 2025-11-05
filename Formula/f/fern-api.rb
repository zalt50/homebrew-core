class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.107.9.tgz"
  sha256 "43d6ef75358ba421f904ae80a946c8aa96bd99944afff68b9ad7d5b079b4e8b6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b806d20bb8235445dbae8b11ee4a43cf2269a3ad7e7a5a3b31f48ff70a330dea"
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
