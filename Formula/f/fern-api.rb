class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.37.2.tgz"
  sha256 "b83fad02c95a400c5149bcc5eff3686ddf156add3c1a9d169200e1e8070a3445"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5e2d3147fcbe6dedb23571d2e932b1f2c3caecc72c6b80d696e7aa284f7ba8db"
    sha256 cellar: :any,                 arm64_sequoia: "39a304dcaba1b15ac495c38df3c2db884265f2cbd5b36e21869137d13eee459d"
    sha256 cellar: :any,                 arm64_sonoma:  "39a304dcaba1b15ac495c38df3c2db884265f2cbd5b36e21869137d13eee459d"
    sha256 cellar: :any,                 sonoma:        "2e93b79db400c15e5f7fc70694f2f68b019412e8fe3e72b1c45d894015c78edc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d60d097dee961f16f610b8345fba13bec73ef8a39e5715735b5e63644b05ea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f128da62ec2bdd27dbfde97db6ca844160bfd862831d6809ccaba042314d6004"
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
