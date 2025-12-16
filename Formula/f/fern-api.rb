class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.24.0.tgz"
  sha256 "102cd698603ff4c83de9c37843ccbeb2bc32b55594da876524319f5e0a155822"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "48e6652ec5e634d8d5371e4d49db3962e99a9138f460d0254d363ff21f88f6f0"
    sha256 cellar: :any,                 arm64_sequoia: "c6bdd617ad4eae6de64ca8a4fd65627ff5767cf1c677b323e41836b870338e2b"
    sha256 cellar: :any,                 arm64_sonoma:  "c6bdd617ad4eae6de64ca8a4fd65627ff5767cf1c677b323e41836b870338e2b"
    sha256 cellar: :any,                 sonoma:        "e62aee7ac3e5cee792e31d2c9304e7790b694a8a3ba79d44e2251babe4c4cff9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e608e332a77166b0c249c1662aab108b160e2b570648ddd06f4bc43395b11eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc5a952e7f2d348ec87b47b3ab928fd22039f5cd8f46ecb4fdd80ed27423f957"
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
