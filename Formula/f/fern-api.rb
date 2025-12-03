class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.0.1.tgz"
  sha256 "eec537b3907fe55129647fce869669b70306948040bb53b41da9c5a049b15158"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc3c132029293878ee098432b4f838ec79921dca88d134a52ff6bb49b01ca03e"
    sha256 cellar: :any,                 arm64_sequoia: "d07635f4acf47a44674802844e44b68a6aade2af55b55044c272b5b4069fe83c"
    sha256 cellar: :any,                 arm64_sonoma:  "d07635f4acf47a44674802844e44b68a6aade2af55b55044c272b5b4069fe83c"
    sha256 cellar: :any,                 sonoma:        "f3fcf280f27a0d22d706aecc692e59ecc5c52448ad5a022cd5df4c87a40aa50c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8e72cc5d82a1f1e776fc3f3ae1a643663581219422ea7f96c0cec086e640331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c626538c5e7199e91fb5a34cde66167cce5007490d00d19bd33ea0fbbb7729f6"
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
