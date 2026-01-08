class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.36.0.tgz"
  sha256 "3cc8de581e70e932e5944cc02f202458aa5055f646fcd9c9acf57a521d8ee994"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "99ae0def9d7d36c668a0d92c8d3ed87e7295daa4d3b4d35c0a483b18a652a533"
    sha256 cellar: :any,                 arm64_sequoia: "e25b11d7ac33cd739faad5ee08e394e5c55c66bf4443e118635890bc540387dd"
    sha256 cellar: :any,                 arm64_sonoma:  "e25b11d7ac33cd739faad5ee08e394e5c55c66bf4443e118635890bc540387dd"
    sha256 cellar: :any,                 sonoma:        "41a3ae5ffb6eca415f19a96bbc11b858104ec271bcc591869a16f94b0d2ad74a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33ef9610dd026af544856fb959f22b96d468028297f89bc4946d0f2ff57bf029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "378f6b95ea0e51733166384915059dcfe69939aa2fcf96bce0bca40e470679a7"
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
