class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.174.0.tgz"
  sha256 "a851b729e90beca4fa742c1ffd58da776a4487c906b11cd0bf6749c00401a288"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "3a4ca75a4df4f99ad00f9e3a0bff7bd211ac96938eda525048b406b34f97e64a"
    sha256 cellar: :any,                 arm64_tahoe:       "3a4ca75a4df4f99ad00f9e3a0bff7bd211ac96938eda525048b406b34f97e64a"
    sha256 cellar: :any,                 arm64_sequoia:     "3a4ca75a4df4f99ad00f9e3a0bff7bd211ac96938eda525048b406b34f97e64a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1859fa40fd761853e8dd2fdce97fc5f018ba496ab9a9746851a2261887ce12ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cd149c62004704a1be0c0be11cc837723dbc76edb49bedccea44a033a7257e26"
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
