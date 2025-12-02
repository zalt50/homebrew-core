class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-2.15.0.tgz"
  sha256 "c5e6ee0fa386ecf33c70ebc8165df07933894f76e97b009c5e50f556962d49d1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3f6b4df9f8b42a020980bbc61d23f162dca45646ac3bc46c4fa7f4dce5209b05"
    sha256 cellar: :any,                 arm64_sequoia: "9ccb043861faf56eefb7514ef4937eb7fe4fb01f3f53b2a30f6bc7d360634dc3"
    sha256 cellar: :any,                 arm64_sonoma:  "9ccb043861faf56eefb7514ef4937eb7fe4fb01f3f53b2a30f6bc7d360634dc3"
    sha256 cellar: :any,                 sonoma:        "e6bca45ff61cec7d2976e2bf54891fcc45f6c17e623727aa79b32914a3183a85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83f96882e4bf53d36cb7dffbb976cb67d46e67e17e44676ab4e298dc17bd412f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08805287cfc3f436c83e79f8bb5a4b8ef9cd7ba1f55190bd71488d1620a9baee"
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
