class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-1.9.1.tgz"
  sha256 "9f24dce928ad25326c8c02b163c19d144b28ef0ff9221321de1a7af812bb48ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21f97115a80f481b80c2ead34a278eb78a891772fb6fff9d83fb3ad89ba96285"
    sha256 cellar: :any,                 arm64_sequoia: "e65d29517ea257ef7c5769d24cff43d424ce78cf7519de65535485e83de6b640"
    sha256 cellar: :any,                 arm64_sonoma:  "e65d29517ea257ef7c5769d24cff43d424ce78cf7519de65535485e83de6b640"
    sha256 cellar: :any,                 sonoma:        "c0631f0cc0df7a76b5e1b313e151e25d4c92e57441bf98a8e0ca802d84629d04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac44515af34b03fc363669d9c0b1de144d3a7181e1a349a1f850171a9f474c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dbff03f4fb1dad79823be0a8a8a84bdf9eae829e13ae24692670495cb8f9f56"
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
