class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-1.11.0.tgz"
  sha256 "f44031388e68de0abf3c2c05ff3ecf3c7100227fa22f274aa69bddafc8193068"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9f6c26041216282117d714feae7cc36ef9380ddf270ae4bacbcdf6554bcf3bb6"
    sha256 cellar: :any,                 arm64_sequoia: "a2246e475b62c3f00d0f2aede44aca1a75397076d9b64cc1487e67cfab7922df"
    sha256 cellar: :any,                 arm64_sonoma:  "a2246e475b62c3f00d0f2aede44aca1a75397076d9b64cc1487e67cfab7922df"
    sha256 cellar: :any,                 sonoma:        "888e5ce0a1988606ad2e04da8d765a0ecdfcc0ca3705a88e9a25d9445eebb9dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35fcaf581369e316188f6915eaf516a243abcd7181cc175ef384d025b08703aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff0de87521a04a81fad01d554b81726ad15c7f1d0dec999e3351152f140b773e"
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
