class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.0.5.tgz"
  sha256 "26de4a5504e4c5417768fddd436673b7901fd9b12c095c7c0ec195082ac1149f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bbf7165283c2d87ce141e1c9d6ff236f85ebb849a538d4f18c3d55c41be610ff"
    sha256 cellar: :any,                 arm64_sequoia: "a39b18c4ca09aac4b80c15d0befcc7e2e2c0608a2cb466d22fbe422cc4b5f217"
    sha256 cellar: :any,                 arm64_sonoma:  "a39b18c4ca09aac4b80c15d0befcc7e2e2c0608a2cb466d22fbe422cc4b5f217"
    sha256 cellar: :any,                 sonoma:        "13b694736c5b522e5a599f4951001cbf03b54b03a78dcba6218fd25115d2d015"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41a3d57405f885fa8113e3780e739ba26e7ed89d973019b16deabcc3808bcf3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cec540494c6de9efebd69170eadccefcc2649b1e3aa3d5eea76cf00b380c0b45"
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
