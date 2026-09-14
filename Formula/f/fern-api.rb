class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.122.0.tgz"
  sha256 "075e771407571fba2d42627469285df99bf0a7aad272167cd1085336fbf0269c"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "342d2fb796568eb8c5de0fed2d54353510048f814a0f5ac1fb5a1bf6b0d41a2a"
    sha256 cellar: :any,                 arm64_tahoe:       "342d2fb796568eb8c5de0fed2d54353510048f814a0f5ac1fb5a1bf6b0d41a2a"
    sha256 cellar: :any,                 arm64_sequoia:     "342d2fb796568eb8c5de0fed2d54353510048f814a0f5ac1fb5a1bf6b0d41a2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5b8265a6a33b27bf9ae8ed85baa5e42c3d00237bb45a56b1204308fd1cd3e10b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "58ca0e64d73c592d0cba528e02f4aa8ec0d6538ed2f27db710b38b9b9b78be7f"
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
