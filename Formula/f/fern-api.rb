class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.1.0.tgz"
  sha256 "1704c222401994f8566f173fd1456fd5add02d92d66bd4d5bff795dd63af9e98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "99ea2deaa8f40e33c38c22bd3ce40f865291d89aa11adf77efaa82c8f67761c2"
    sha256 cellar: :any,                 arm64_sequoia: "57818391cd4f9fb18675eddce347220c531a5ed96cc2e33320b9f53a6be012e3"
    sha256 cellar: :any,                 arm64_sonoma:  "57818391cd4f9fb18675eddce347220c531a5ed96cc2e33320b9f53a6be012e3"
    sha256 cellar: :any,                 sonoma:        "0fab7a178abbd48e71d03087f44a86f84c1b7db9151cc889bf288e0f91501f40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f30f68f7fa5fa58bcc899a5a78a0cf0b932fcffff6f01a7035a3635d9c5a573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff57016aa6be5e1e0c8b810019d228324078692e1e523e462b1add04f53c7786"
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
