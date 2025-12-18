class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.26.3.tgz"
  sha256 "9c9d268ab79b2e4ff0360cd1a106973d9a998617db6dd8e9cec9cede98cb0712"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "53bfb9750d2b28ca4a67cbf068c92afe01f3e6b29ee7289e125c41f46fa4a94b"
    sha256 cellar: :any,                 arm64_sequoia: "17d0ad10dc3ee474efef0c57206fd5efb0219e74868c5abdc6e8dc69cbedad1d"
    sha256 cellar: :any,                 arm64_sonoma:  "17d0ad10dc3ee474efef0c57206fd5efb0219e74868c5abdc6e8dc69cbedad1d"
    sha256 cellar: :any,                 sonoma:        "e13d752bfa40b0e04948c23fa16e44835cd5b52d791ec143e7b1dccbb87394e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa4c1755ce60334ba33770a9325ddb45ea626fe45256519030a2fe4ad35f0996"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "934a94e5a5a9ba58659c0c8e67fbfa95d6768146c797e7a0f6711d8ba7bb24c5"
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
