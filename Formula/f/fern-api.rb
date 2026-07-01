class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.62.0.tgz"
  sha256 "d96d170735413f770da177d41ee3524b36a94244c258f654d85c709562d56cee"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1fd353fdf1e7bb52b0e1c4b31e661cd9c020823227fa3aeddc3b5789f09e6656"
    sha256 cellar: :any,                 arm64_sequoia: "1b72846cadf80ef940a305c5c21e931cc44bdf1b31602c52fe8f13fdb9d145c0"
    sha256 cellar: :any,                 arm64_sonoma:  "1b72846cadf80ef940a305c5c21e931cc44bdf1b31602c52fe8f13fdb9d145c0"
    sha256 cellar: :any,                 sonoma:        "037b68d91d567efe5a46a1b5fbdf9ff09db3a7b34e81e6de7f54460beedae0e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a538ed3bb35d150d6ab0ece5c92062432171965d7f6515e647d27d4f7fb27d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5296ffd9827964ec227f30860c25f251de8b3a09b950240de9d9fde5aa0ad0c5"
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
