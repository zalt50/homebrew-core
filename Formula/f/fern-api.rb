class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.41.1.tgz"
  sha256 "3af20dbc10b6521b5eae6c910db5289266de6c0be22bb432283c0b848b8819d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0b3fa036dfb7e2a96fdb44d33ac82c3a88a5d5a66f5523a2b78b094c5bddcf31"
    sha256 cellar: :any,                 arm64_sequoia: "25b38043b793dfb436bf309ccad6698cabe2a95bf71e67a3125b7477ea0aa83e"
    sha256 cellar: :any,                 arm64_sonoma:  "25b38043b793dfb436bf309ccad6698cabe2a95bf71e67a3125b7477ea0aa83e"
    sha256 cellar: :any,                 sonoma:        "a62a7c92ee0c2871f7cbdfba8e7ff5c81ae3cf7acac584cc574cb2ee3169c8e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42d92baebdf9cad19381966ebbeb9d29bd84a204e7793a9e3972028e3b5cf1fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6957a14bed0cc68294f830c36d8ab7e92ea16fa17f4f265c20ca745ce85cf29e"
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
