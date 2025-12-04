class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.0.3.tgz"
  sha256 "cf6d0b74fbc56d0dbff16c4fb715ca33f807329691c1b3564074946c5dd72aa4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dfe11d09a85a72e7b505a0d58bec8342daf70fc753e42ca13452995bbcfa9ec1"
    sha256 cellar: :any,                 arm64_sequoia: "d90e8eb9c07fcf9a10b3c7b92d2936bdb16d98428fda7744c3ae1fc8dfdae168"
    sha256 cellar: :any,                 arm64_sonoma:  "d90e8eb9c07fcf9a10b3c7b92d2936bdb16d98428fda7744c3ae1fc8dfdae168"
    sha256 cellar: :any,                 sonoma:        "899faf35619f7c723931af8234c0ba24a79b09e831b5599f0f0a7ba32be3daf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eecce42546011410fc88d89bcd246554958b8b59e54630fffa0563c84bcbf12c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d37234b6507e42e54bdb96220f35be24c6bad98a9455c864e203efc187e62d9"
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
