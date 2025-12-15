class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.22.2.tgz"
  sha256 "dea8bf711b3d23649539ed0decc2091a28706f84bc5bb7eb247edced56b18f84"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1d37be40624e2541d0c9f614e1791dfcba67b23b6d73a381de931f3fc73a6c15"
    sha256 cellar: :any,                 arm64_sequoia: "899a1d6427ad2923122f9e96b94b43ad5970de99c0a7cd0494b631318fe01795"
    sha256 cellar: :any,                 arm64_sonoma:  "899a1d6427ad2923122f9e96b94b43ad5970de99c0a7cd0494b631318fe01795"
    sha256 cellar: :any,                 sonoma:        "a8c537d1aee45eff9d33d9c70c5e10f457cb669270d82fbcd49f3ae71e2e45e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d05f7cc888ac75c7494e45dd7e7a3a1e48ddbe93e7ed64619accffb76e5f4a24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2563226c140b7ff3db9fbe77d42de48b8d14abf4e0bdfd1903ed27623b054fc5"
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
