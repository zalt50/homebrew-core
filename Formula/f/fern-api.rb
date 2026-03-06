class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.13.0.tgz"
  sha256 "8a6b2241775f06cdb9ef967e09a3a7346fb1f9abbc0a2d353bf8758e4908c9f2"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e0ebff06d2089cff9357baa9ff4306563ac45896a6385e71259e6ccc1242d227"
    sha256 cellar: :any,                 arm64_sequoia: "cafd6ec866b6d38fe8b52a22d4bb69dd55ab1e3a29e6087a712e94a469816611"
    sha256 cellar: :any,                 arm64_sonoma:  "cafd6ec866b6d38fe8b52a22d4bb69dd55ab1e3a29e6087a712e94a469816611"
    sha256 cellar: :any,                 sonoma:        "9e7f1a8b46bf50bc3ae38cfe97c80407fffb7bb3b88709b336fcc065c5493098"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "599e973b6eb4002680aca4c12b9262352f0b1ccdf6958b212284eac1d99b6c4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f96ea292126655c1a64aa1bf7d17e9c0f7609163e9e2bcfb101304579693d9b"
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
