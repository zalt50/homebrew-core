class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.39.0.tgz"
  sha256 "8d71d6f45795eeadb46f532d56dadbed292697b16cebd30d4a83415249222e06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f84deb33a172ce76cdfbd78eabc9090d7429feb56c565cc9ebb11a71b125eee"
    sha256 cellar: :any,                 arm64_sequoia: "8816f6a3657be66187ba5aca01c1c4f72a1ce53b83df7f5fe6bd2c8d48e764e3"
    sha256 cellar: :any,                 arm64_sonoma:  "8816f6a3657be66187ba5aca01c1c4f72a1ce53b83df7f5fe6bd2c8d48e764e3"
    sha256 cellar: :any,                 sonoma:        "24b8a4f7e4676f69c08cbfb5b3501edf1a68c7e5dbbb5f4daefdbc23fbc2aa12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f86cd0c03087e4d19b5fc2cf7e912321165a4ee1175acc124ff3e7ff019d45d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7da90a20808694d5f8245ea71ab511da27ed25bd4349db8da85e7f0be037b0e9"
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
