class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.26.0.tgz"
  sha256 "f8f7e6c48e347013a90e940cff10c0eae8daf320ff3ba389521ee00f4b2c07b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "90c4d7c5423ff2fdb294c18bf975701e9ecfa48e633755506762fc585eb56f72"
    sha256 cellar: :any,                 arm64_sequoia: "e29223cf0a3cb9cd8cff669c8f2352c61b81d53ef2620fc977a8c811cf8dda19"
    sha256 cellar: :any,                 arm64_sonoma:  "e29223cf0a3cb9cd8cff669c8f2352c61b81d53ef2620fc977a8c811cf8dda19"
    sha256 cellar: :any,                 sonoma:        "4fa4320b3c9d7ce4c777d9f22bc0ed52d4eef1e3733bad4d29fc83efafbf257b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18cf669555fb056f685896ebd0d2d3cee69ada5e02300bf981762ac9f67a215a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "162710baf09d636bcc1554a383f7100dc3abcc530234109a443dc1e04e9f2e54"
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
