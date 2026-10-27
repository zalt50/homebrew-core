class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.175.0.tgz"
  sha256 "a8ae531f9ae57821dec34a2f7aac9dfbec8b68e97758b3f1e998d26f6ba3269c"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "b659f28dbcc43a22276527c164e121d093ef26c2384ba1705c5170015cdc6ea7"
    sha256 cellar: :any,                 arm64_tahoe:       "b659f28dbcc43a22276527c164e121d093ef26c2384ba1705c5170015cdc6ea7"
    sha256 cellar: :any,                 arm64_sequoia:     "b659f28dbcc43a22276527c164e121d093ef26c2384ba1705c5170015cdc6ea7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5d79c21ba98298d107ec964768e554cb1eb8eb65b956d93187ed8788d430c410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1275b324f954485c200074f56cd29aac126dad84a29abd0805bf69ca97623cec"
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
