class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-1.11.3.tgz"
  sha256 "25c24a2cea3bf96019039f8e830b7970b2ba1cd18bf688b93e50fc64776b563f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32a4e0d9aa2a9e341dff4187164a158cd179b444edf65c2a19923128cc6dab6c"
    sha256 cellar: :any,                 arm64_sequoia: "ca66ca2481941fd1537af2958dacab5a056466a466a50a63bb2c3d02aba62cd4"
    sha256 cellar: :any,                 arm64_sonoma:  "ca66ca2481941fd1537af2958dacab5a056466a466a50a63bb2c3d02aba62cd4"
    sha256 cellar: :any,                 sonoma:        "d5a329e9e2f62f5856935a1a88585d7bb6d2ee5b0ff80d5a7fda5c68963fab04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c755727d68ccdb02fb3e20b3051b1809d77425a524bf71a7636d2d7b50d264a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "187a0b89d08ddf8ef41af2462980b2e6d120dd83d324c455e660272cdc398491"
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
