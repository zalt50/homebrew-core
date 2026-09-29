class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.140.0.tgz"
  sha256 "1330455b811fa164cae21ed8d1401921d27f4f11ddf5c7d491806ac18a12e318"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "6de03e1d746a9d971936541300b29ed8d3f7e82b2a437cc333f1cd7b4bf8ad20"
    sha256 cellar: :any,                 arm64_tahoe:       "6de03e1d746a9d971936541300b29ed8d3f7e82b2a437cc333f1cd7b4bf8ad20"
    sha256 cellar: :any,                 arm64_sequoia:     "6de03e1d746a9d971936541300b29ed8d3f7e82b2a437cc333f1cd7b4bf8ad20"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "948950089b409792f7a0b65bdb82d8973f53685ca2880e4658b92147bc5f6606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ebaa4f402f0fef08fc87217012384f11e2751ae83bcfd3c489604820cf9146ca"
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
