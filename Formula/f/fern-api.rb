class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.185.0.tgz"
  sha256 "c5d8053be2eb2736a5a722b6f95559f75b5021336e364a06b789612ba5809ee6"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "1266b489a0cfd144539060e91d91bcb976c09599144aaf68ed2a9f638dd8a00e"
    sha256 cellar: :any,                 arm64_tahoe:       "1266b489a0cfd144539060e91d91bcb976c09599144aaf68ed2a9f638dd8a00e"
    sha256 cellar: :any,                 arm64_sequoia:     "1266b489a0cfd144539060e91d91bcb976c09599144aaf68ed2a9f638dd8a00e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0615f6dd518b9d696c9601c187be5e14b0ee3021f190ce6eb0ec8e3567a045da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "96a57d59eb04c864ec20054d0c262854152ff31be2d15127d541706bc8a014b7"
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
