class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.21.0.tgz"
  sha256 "c5e92eee3c6c492d40832db899d2ccea15465f75d7a5d74eb4f75be2e69b76ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ca9a4cb6ee99191557bf94f6b580a7c578be96b2b4d4888a5a99d061f84ead4"
    sha256 cellar: :any,                 arm64_sequoia: "9ae0cba7319bdf2c36639c863733792f163ab5fb67d3f6d47a124263a8cbfb4a"
    sha256 cellar: :any,                 arm64_sonoma:  "9ae0cba7319bdf2c36639c863733792f163ab5fb67d3f6d47a124263a8cbfb4a"
    sha256 cellar: :any,                 sonoma:        "065d63331fe7ad852fc4ee4e681f23b72f8d19c15801498eb1dbdf5f460d6ed8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec8f0f9052e03afca74525703972bb3f9a2cef4fbd0425f638f7690ba6e14b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cdcf054be054a78263097db5eb402b27bbd6ad7e1812c883e94f5fe35b9b549"
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
