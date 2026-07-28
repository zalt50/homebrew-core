class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.82.0.tgz"
  sha256 "b9d68cc74387fda52f46f839034689dc429b28ab0709cde6883918a58139cf04"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bb5cfe64888668a808fb78ff91772c3d25207f772d48a7eec68753624ce69ee8"
    sha256 cellar: :any,                 arm64_sequoia: "bb5cfe64888668a808fb78ff91772c3d25207f772d48a7eec68753624ce69ee8"
    sha256 cellar: :any,                 arm64_sonoma:  "bb5cfe64888668a808fb78ff91772c3d25207f772d48a7eec68753624ce69ee8"
    sha256 cellar: :any,                 sonoma:        "fd75929e7adc6c1d28a72a2402ea2afaff009a4a765920cdf53092f8b877ab76"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c27b9adc6dec4431c6b5da499c1aa7cb40d3ca041d29ec7030037e02c5105811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e157d8e1724e9edda11b797b283f599e9d922f09d87df564d0852fcffd54f1f9"
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
