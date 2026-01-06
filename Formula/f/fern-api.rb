class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.35.1.tgz"
  sha256 "cfe00f204e70d7f448d5eaa35f758308863e9af8a885483f9ab914ab75684b51"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e911e22b09ad6eee75f2aad59e9ab81b2eb0f129df10ff35f33348c02df7072f"
    sha256 cellar: :any,                 arm64_sequoia: "11be2ac13b9c4c84a3feb25a53a1459e504c165bf079a36bfaf5b4d028bc8370"
    sha256 cellar: :any,                 arm64_sonoma:  "11be2ac13b9c4c84a3feb25a53a1459e504c165bf079a36bfaf5b4d028bc8370"
    sha256 cellar: :any,                 sonoma:        "9a331803e3f4f763cbd46f32453cf974b7a0ac7409442f46e925db94ca60ddd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a36b61726a25fb2bfc033ed3791da7cf5ca878ba2e64b54797ba3a804861a8d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5409e1a2daa11b9b4184e28aff1ce9c3a828ca31f4d38fcc3f27b3833da3a129"
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
