class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.77.0.tgz"
  sha256 "ee6b429bb88ef5424eed4535bf74088d50777abdfb9ceeafaca2ac832b409e31"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6ee4a7969fe84fc6fbd0af25747a90f34d95a56cd220c8c4800e942a52b0f5e8"
    sha256 cellar: :any,                 arm64_sequoia: "6ee4a7969fe84fc6fbd0af25747a90f34d95a56cd220c8c4800e942a52b0f5e8"
    sha256 cellar: :any,                 arm64_sonoma:  "6ee4a7969fe84fc6fbd0af25747a90f34d95a56cd220c8c4800e942a52b0f5e8"
    sha256 cellar: :any,                 sonoma:        "8ef3c22e4730d278c7445e8783d803d3ac1397fe3da76bbeed631ed32a7bc092"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef91a0a0e5ad0f5b0d7dd24cb68b770287dfdc12915c8a0062074073b8683976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c4eb24fb0d2aeb5e687e495f4c31554100ffc283f033a322ab946eb99583d56"
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
