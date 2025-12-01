class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-2.14.0.tgz"
  sha256 "a73e3c5e4e77cf81781a6ccc1a35885ad6d4ea7382aa6b31e380bd4da05b0d41"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "611bc7992ab79f78ae505010cd2c55e0ee222bb01976afb74b1d3597ae8cc3db"
    sha256 cellar: :any,                 arm64_sequoia: "012c597e2793c2ce585f6f2f3f58b9788e2ae6a946087bbc172e3eedaa760d72"
    sha256 cellar: :any,                 arm64_sonoma:  "012c597e2793c2ce585f6f2f3f58b9788e2ae6a946087bbc172e3eedaa760d72"
    sha256 cellar: :any,                 sonoma:        "4c89d4aa7a20721fba06a14a48c92fb311209ced2c30778d7c602f3fad430fd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f9e9609faa2ecfdee0eba0af0b02223c25b62904e06502ead4642ed3458c0a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b790202ef0157e048d7c6ffef625f21cbf6787db594693284e1b0441a21edd4"
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
