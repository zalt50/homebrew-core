class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.19.0.tgz"
  sha256 "a6ff03b42ed384cd2574919981df26ead99797dfd64c56ae2b3a57f845e3f29a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "71322c7acb691b7f35c3dc119cc8a09d826df1c7363a432eb0420e39575c0544"
    sha256 cellar: :any,                 arm64_sequoia: "f5badb4ba95c82d3f0993c368d394a9d7490da2d9e89ab85909ccd41dbfedbbf"
    sha256 cellar: :any,                 arm64_sonoma:  "f5badb4ba95c82d3f0993c368d394a9d7490da2d9e89ab85909ccd41dbfedbbf"
    sha256 cellar: :any,                 sonoma:        "c52d81c8f8f189341bdad4a19fce1db446a52e13075dbe5c4c58c727c67ae5da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c467470bea21fc6ac6c9c243a950b9d454f122e4d3192124c3c920e62dd68e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b26c13e30608a4e5308d193bfebb6d22e5e70f51866bece24654b6723fb3a771"
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
