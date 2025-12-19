class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.27.3.tgz"
  sha256 "7983f6bfae0ed314eb4d053ce9d0a0d881a4bcdb0ccdbc79660b04b4bbca98f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ceb76f67929af5d9783ce81818f1fdcaacefaf8b8fcd1003c41bb6c2ffe6082a"
    sha256 cellar: :any,                 arm64_sequoia: "7e15774890f661313aad3d93b114490dd32735d55faf878fdc1a74527495f114"
    sha256 cellar: :any,                 arm64_sonoma:  "7e15774890f661313aad3d93b114490dd32735d55faf878fdc1a74527495f114"
    sha256 cellar: :any,                 sonoma:        "b0af24d7418d78540d5fcc697d506d1e2fc94ea5f4b5201f15dc47ee67a287a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bf8b6b2e9173f0909bd4acb7ea7ffdb42ea2f9ce6aeada1d04cec4ddabf8618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e22cbcf8ec2463a626cab08dcec1192d3954b0d641eacd96df0b90806b442867"
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
