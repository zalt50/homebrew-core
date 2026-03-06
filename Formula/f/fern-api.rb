class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.14.0.tgz"
  sha256 "64e6270b6fe8ed0b6671a89c27ea72ad23bf1cfbbd903fb216cb7dc77f5ea512"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d49ae25c1390a1a3e221dc5dc549b53cd66cfd6296369d7c8427f6dfa35e45a2"
    sha256 cellar: :any,                 arm64_sequoia: "10aecfb597431cc6e02fbbb59a86d286674e6ed259ae8027cf50515df5db4573"
    sha256 cellar: :any,                 arm64_sonoma:  "10aecfb597431cc6e02fbbb59a86d286674e6ed259ae8027cf50515df5db4573"
    sha256 cellar: :any,                 sonoma:        "adc2ffb1788dba45cae136a8ae1899e27d441493a12eec5b2895c740be9222d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9289a3e6171b116f020b131d93f2bf2ad4c9d7f251b9683bf0e09c4716a5a68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "deedb7c1571eff092b62546d62247da802a87c03dbf1e235c938f2d7e0004c78"
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
