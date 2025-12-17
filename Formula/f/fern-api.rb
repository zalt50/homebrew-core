class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.24.3.tgz"
  sha256 "e4a19ffa7630278617a7734bb4342ff32baed352c59cce18c3fc5e0d1afb9b31"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec718dd7cfd2de53a179eba5b449eae51497b57dc83793b5b403aff2863fda0f"
    sha256 cellar: :any,                 arm64_sequoia: "e01a2f766e30ec4eb669e7bfa0ff10cb8211ced32e79065a058f9c8a550e63d8"
    sha256 cellar: :any,                 arm64_sonoma:  "e01a2f766e30ec4eb669e7bfa0ff10cb8211ced32e79065a058f9c8a550e63d8"
    sha256 cellar: :any,                 sonoma:        "5b576c0755210b318a1db2da7302c2d27305ffad672899b737d236e5dd58c41a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e6c37b62218716c096c61975e863faee004181297d5fbc55b6fd5f0e84e6d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21f52af9f94720c00858549a6ca90829a203f4eb91b01aab1785c8f71890eca0"
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
