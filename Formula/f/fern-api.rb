class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.24.3.tgz"
  sha256 "e4a19ffa7630278617a7734bb4342ff32baed352c59cce18c3fc5e0d1afb9b31"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ed7514117dfc711c1c8f1d33bdbb0303a1f4287796131def85539eeee2df5648"
    sha256 cellar: :any,                 arm64_sequoia: "6715534e451a0883a667ea1e37109e0272544eea195a78c14a7133b29b33d84d"
    sha256 cellar: :any,                 arm64_sonoma:  "6715534e451a0883a667ea1e37109e0272544eea195a78c14a7133b29b33d84d"
    sha256 cellar: :any,                 sonoma:        "fde758028a86253225a14ecc26442e34177489c46322d5a6432d7bb4de73b080"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "682ea03d562e27567d71db974e3df3352be637397b7e7a8d1f6c71c81730fb71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afa0ba453e3fadfeae2ec7cad3fee847e7642a880d820ccb67a96b539efddbe7"
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
