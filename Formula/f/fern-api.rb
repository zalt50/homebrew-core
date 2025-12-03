class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-2.18.1.tgz"
  sha256 "6bc01c86d48c501b3813a1f8d93839c98f47a8de39fb6c05b797c86b70f7cfdf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "20f9a45e7b5dd0eb7acda0dbe9a6612ebdad428baafdfbd762118cbb273f2b2c"
    sha256 cellar: :any,                 arm64_sequoia: "db7c8f20fe114d86d4d82437fa20ad77a0381fa3a7c95db8f3d89e7dc8bea3d6"
    sha256 cellar: :any,                 arm64_sonoma:  "db7c8f20fe114d86d4d82437fa20ad77a0381fa3a7c95db8f3d89e7dc8bea3d6"
    sha256 cellar: :any,                 sonoma:        "0b247b0dd643d3e49055ed821e653b59dede14b6ae491f099dd4dd6ce54cef0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09a8a5ce911e519bf506836dceeeb3de55bacb2335614146ee378710be74869a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc058951d6668e2f4d03ffb0882b78f3be66ef5d4129ee126e5d741151d2432f"
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
