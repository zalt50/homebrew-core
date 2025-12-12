class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.15.0.tgz"
  sha256 "6eb255351c4d0c5b75c1fd2c62fc52bd9c4e30b37ab046c0a6d71dc78af8849d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6cd90009b1fee7999806acf3da6ede6ae362d6d435a83170de0ec1998b19f753"
    sha256 cellar: :any,                 arm64_sequoia: "2de80b10433e3a95e7a91473532f11aa73771ca1d301b786c74ce41d718edaf1"
    sha256 cellar: :any,                 arm64_sonoma:  "2de80b10433e3a95e7a91473532f11aa73771ca1d301b786c74ce41d718edaf1"
    sha256 cellar: :any,                 sonoma:        "474f3f1d474ffd930eade703100232f1f8bb4216275262782e2c65a8b6620965"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd2062fef25b108b9084ea6940ec90ffff9c74895f7426ce01b9ca98e6b65a40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7613d33e568a511d01fa0d240bb6edf10a6b4c4a4f842a37873724a228aeeaf2"
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
