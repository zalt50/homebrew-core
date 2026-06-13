class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.49.0.tgz"
  sha256 "56b107c833f934c0ccb64c84d67a288168f428d5a7cc5f77e4942709156beccf"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d05e944488645a9ac538de2211168af0e47aa5818c2ba9f95b801c881b1d2e32"
    sha256 cellar: :any,                 arm64_sequoia: "ae1451df478e37bdda203ce9b6a26f4253377fa16219425889fbb643d0b6a6ec"
    sha256 cellar: :any,                 arm64_sonoma:  "ae1451df478e37bdda203ce9b6a26f4253377fa16219425889fbb643d0b6a6ec"
    sha256 cellar: :any,                 sonoma:        "0e5d2106cc8591c4b2e941166bca889086ec996c75dcdc4f938124e3ed24be5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdd550f129dd48dad8f2a99b01d1150a05f0b183573294dc2db2c97ce2702ec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e45ceb1f596cef6fe425d417b04adecbead021cf863d25fc1d8109258a09bc84"
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
