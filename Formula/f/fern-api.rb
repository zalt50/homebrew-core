class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-2.17.2.tgz"
  sha256 "d815b016d128052a875edfae4fa1cb123f8775a6922ed799fafbe39fd6f0c6a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5cd8f6e10b640318deb91a40b9e8c884f88a78cc7e3de2b9abb64ceab1ac0716"
    sha256 cellar: :any,                 arm64_sequoia: "18b4d9a8dc0e62cf7a11bddc73178979da10c67b95fbfba5a72b25943733b808"
    sha256 cellar: :any,                 arm64_sonoma:  "18b4d9a8dc0e62cf7a11bddc73178979da10c67b95fbfba5a72b25943733b808"
    sha256 cellar: :any,                 sonoma:        "2714c20bf20d8169343e460a3cf0a4fbdd0c77e51ef3e9dc18b8a8816e4e89f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "030346476201b004a1f842f09837665b0e6a61e7dfaca2ded788dbcfd4195446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46c706827794192081250c7d3e565c93ad7e7ef8b3bae5d70acfc9ebcd3dc30f"
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
