class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.29.1.tgz"
  sha256 "f107a70ae62d119f89294dfd1373523634c29ca5e1db015e07759d51aa828830"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "619a657ec7f36edafc5532ab4a1bee7547ebac4baeddfc3517db3513310be76c"
    sha256 cellar: :any,                 arm64_sequoia: "7517f532f55f37ec6b8ce670ad49db09c6dcd6f0464e0912cf7872c70ccaaec2"
    sha256 cellar: :any,                 arm64_sonoma:  "7517f532f55f37ec6b8ce670ad49db09c6dcd6f0464e0912cf7872c70ccaaec2"
    sha256 cellar: :any,                 sonoma:        "8b914331dd304d2cf28e731d16d16c3bd291d4172b74e51296c4dbbfce13084f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20591d47c80c76847b8c5370454a8bb4e94c8e034dacc72601af6b0797f98fbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71179e2d454c6a231a1d3d78e5300a0ffb8a5eefa8f8e431e39c48c066083d51"
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
