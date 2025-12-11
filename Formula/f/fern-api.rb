class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.9.0.tgz"
  sha256 "91655fd9b8348b70e8b382ee55ca2eaa2b333cffb638d0937988bc949c6bdb31"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "735edfe727a5cf3106da8c96de1d9adaaa24808899f91edd3b7b09f80bd3d22b"
    sha256 cellar: :any,                 arm64_sequoia: "24337cb17818dc6e35e87dfc9fa1bb3219f9627dd80b44f5162519dc1bfd2a38"
    sha256 cellar: :any,                 arm64_sonoma:  "24337cb17818dc6e35e87dfc9fa1bb3219f9627dd80b44f5162519dc1bfd2a38"
    sha256 cellar: :any,                 sonoma:        "895766f8c552ba0f0c8c299e5d2fa4ecdb2adddb24e955c53e26606ca5e2ba1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6897f14c4bcdb1da1abcc2c7b5ee325aab80e2334029b60ba196bc25adf31dca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce24af8ca742a96050169e85581766c6f7c7ee1fe25aab6bc30d61d3bda9a947"
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
