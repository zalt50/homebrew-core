class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.37.5.tgz"
  sha256 "cd894a35d41746d7ab2510b3d65091dc92c13d52ed0ccf7b2fb371cd44528aed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "27624dcdde0fa4602172c6a34952ac674399db06de6f2a7a90075908d208490c"
    sha256 cellar: :any,                 arm64_sequoia: "5fa8536f75c5c52ff5fce054e3aebebdfc5c94b8369d684331b3506e4ffb3449"
    sha256 cellar: :any,                 arm64_sonoma:  "5fa8536f75c5c52ff5fce054e3aebebdfc5c94b8369d684331b3506e4ffb3449"
    sha256 cellar: :any,                 sonoma:        "febff255d780a6290d79395416c9df12a0fb398b5eb22adbc0dc1acca2625efb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d50ba53df7e0d92f3510d31897f9cc0070646bd3c466ff62b3a4825f7f31050d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "477baf67d6c4d9e9d4074009f778e978037dd417f4ef442358bbc284a1b59749"
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
