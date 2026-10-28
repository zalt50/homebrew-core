class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.183.0.tgz"
  sha256 "266fe1db95fc11392a089dd8d62060779b7dbfb9414abfeaf7abf8af16e30888"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "d26e541495789cc85b2885c706c1c27118884178674cdc7fef5f33d4881f7752"
    sha256 cellar: :any,                 arm64_tahoe:       "d26e541495789cc85b2885c706c1c27118884178674cdc7fef5f33d4881f7752"
    sha256 cellar: :any,                 arm64_sequoia:     "d26e541495789cc85b2885c706c1c27118884178674cdc7fef5f33d4881f7752"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1e1c169badd4ae3e9bb89bb4917ce6b6cd1bc1a0b270be4f06f87d77c4f3e7d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e37f7646e894429f58c8a6f028a22eabb2d06153a9f39e9fe7df6c56888a2441"
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
