class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.44.1.tgz"
  sha256 "7fb8bcdadcf5ca4d9e7537c9a9209534a9c7115fd3d055b7c8a6fc6315baaa76"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7646adcd258479a6f85482a5d152acf46536ffc7316641c397ab2ffb83779231"
    sha256 cellar: :any,                 arm64_sequoia: "20d277b7f2f7d46b288248bf18cf009259ffea7b29cc804aacaae2ea6d110dbb"
    sha256 cellar: :any,                 arm64_sonoma:  "20d277b7f2f7d46b288248bf18cf009259ffea7b29cc804aacaae2ea6d110dbb"
    sha256 cellar: :any,                 sonoma:        "60f273ef0d07308a76c857b1fbd6f33b5b65cb55a440bf269d0606a910c94780"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dc648bd109387d7f1efe9a5fc28a37539eb24007747889d6e89234df0a1b534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d9e190ed389681e14bee69763a0e448c05f8773400d8caf42f9651870829d21"
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
