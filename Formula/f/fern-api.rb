class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.21.0.tgz"
  sha256 "c5e92eee3c6c492d40832db899d2ccea15465f75d7a5d74eb4f75be2e69b76ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c4d8f21da6cf762f234ff3391899cc30370a3ffca2e1d9c8aa0b92550ad460b"
    sha256 cellar: :any,                 arm64_sequoia: "e8bd736cbddbf73ce830c506fbe38048c3d6daa397a4a6acc9a80a793b4d02af"
    sha256 cellar: :any,                 arm64_sonoma:  "e8bd736cbddbf73ce830c506fbe38048c3d6daa397a4a6acc9a80a793b4d02af"
    sha256 cellar: :any,                 sonoma:        "4c824689d128a89faa7bb267fd68356eedbab6d971d3ff287d6c6c232db38fd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7f2f698755ad0f087c5eae3317779cc57974be08f79aad53647dd247e0e17c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "675bc90c6a4a47cf44a34aa7ab946a56d5ee72c576f64fd15b1cc4e2110df945"
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
