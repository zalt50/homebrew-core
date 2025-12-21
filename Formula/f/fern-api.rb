class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.30.3.tgz"
  sha256 "d51b3427d0c48a98169b4c0b07b255ea83123f45648e2cf37562a6a22e9bce67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "559df20c3ef4ab468dbe99f93915f40bfee473152076c90b7eb36feccfc11ff5"
    sha256 cellar: :any,                 arm64_sequoia: "d43cf07b515316636894c438707bba04671a9e29def92a3ac82c84add52ba9d0"
    sha256 cellar: :any,                 arm64_sonoma:  "d43cf07b515316636894c438707bba04671a9e29def92a3ac82c84add52ba9d0"
    sha256 cellar: :any,                 sonoma:        "b59867164e216086738ed71b56bd9cd1a1c9306a442a9a90c7afea61050beb3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fecf0d7af21cb54907193746f135211f8b610427c09e6cd635d78d9e4832186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a00d7d8b532c5da633690b70ca334479cf6caa53637e360fbdd245337ae1fac4"
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
