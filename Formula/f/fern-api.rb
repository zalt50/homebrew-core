class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.4.3.tgz"
  sha256 "4046b504f475d0fb38fd468111973fd4c80f6d1723d36aeeb0b287a88322729c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b2e88f360f3af70ce722a8ee66eeeac05d89c4a6d216a27564e53bbd710e5664"
    sha256 cellar: :any,                 arm64_sequoia: "e20040be718f59173283c339d9e4f2eb3e2274a27ad335c012f6a60d4ec4548d"
    sha256 cellar: :any,                 arm64_sonoma:  "e20040be718f59173283c339d9e4f2eb3e2274a27ad335c012f6a60d4ec4548d"
    sha256 cellar: :any,                 sonoma:        "bc66f29c71c96fd91bf957dbac83e043c5af34ee7cc92685bbf0ea3d2de0ae16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5deb23e5eddaa5a33cb457420440f97b04511cbc6336b1cfb91fae6c5c138478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5da0b55fa08674c8f21975961fb1398e2f2a09b21452397a8544e02792a0c980"
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
