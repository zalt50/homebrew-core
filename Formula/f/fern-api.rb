class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.31.1.tgz"
  sha256 "2f08c7ceb54608be8f49243c646cd3f46f5c7bd296bdf663d852aed430b70e24"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a4ce0919689f97f6b0ee8fd2a2bf16f474b431eb45c97114fc04af5812728ac5"
    sha256 cellar: :any,                 arm64_sequoia: "4f52717bde93fd86624aed590e75f3a3eb3ff991163bacfa64eb5e9fe6258e3a"
    sha256 cellar: :any,                 arm64_sonoma:  "4f52717bde93fd86624aed590e75f3a3eb3ff991163bacfa64eb5e9fe6258e3a"
    sha256 cellar: :any,                 sonoma:        "079be4d821fd570a869f5346cc6cee990cd0434ef3ebae70a6bb828f89362eca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "846349ae686631913efafb5b444e7b9f6841f84ce0ad672ed292af8a88a6dc41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba66c141f784c03e12f08950fcf1f6c7708e6384a7db0c0b717a23e7ce963e79"
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
