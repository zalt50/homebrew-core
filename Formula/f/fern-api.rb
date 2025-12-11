class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.11.0.tgz"
  sha256 "8801be3d94f8e9819d2abce7a4878be27bb211bdb7627a422a4aeb12bfa17a94"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cde10e41bb4f018692f8f76c3e400388944789a8b0d3624cf5ccbc20a0812d96"
    sha256 cellar: :any,                 arm64_sequoia: "65a0f24bfac25f4d256896ada81003103a2b4ca26691dc89d924f81ea7c04cdb"
    sha256 cellar: :any,                 arm64_sonoma:  "65a0f24bfac25f4d256896ada81003103a2b4ca26691dc89d924f81ea7c04cdb"
    sha256 cellar: :any,                 sonoma:        "b8eaaba0c527d3933e749ef4a10a29a795b60a648cd83dadd7745034b1a20382"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5db0c2d23478a6d986b533088024abeda05383c4244ef7f199c3b0519be8b314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1d2f095357c9107cf55a185f869db15f2d60975991217f09b53a88087952c07"
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
