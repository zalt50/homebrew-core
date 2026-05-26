class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.38.0.tgz"
  sha256 "e0574687a6efb9c576d6cd416a2a28550f2627d50efb40f610358256747ec903"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "85a4babf0d38458394fc5dd84f94049e2f672be6b7c4252d50dfc331925fc3f2"
    sha256 cellar: :any,                 arm64_sequoia: "52e1485d544e0c6b9de1e9accf535aa7d3a6c8d7e7a952546a9cf82943e7bbd3"
    sha256 cellar: :any,                 arm64_sonoma:  "52e1485d544e0c6b9de1e9accf535aa7d3a6c8d7e7a952546a9cf82943e7bbd3"
    sha256 cellar: :any,                 sonoma:        "71dd9ee0b57d3c59ff952d46ea7f94a5d817417510bc62fb8e45177e19a07964"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afb199c41418e3fe4b9abfdefefe60555be9aed162281f1b31a2a0acc1e60316"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62004040b7dc857ff806c12d12c184e8431c43c99bc2f4bc0433ba47975793cb"
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
