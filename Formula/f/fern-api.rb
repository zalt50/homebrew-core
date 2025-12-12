class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.16.0.tgz"
  sha256 "8f0b250137906d5463323358ea5af3aada82b8d31fd370b124da7aa7ee100562"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "42a1d716415ea9c8ca544a3e3b31e2a7c74139619270aeedad16c16e5347cf34"
    sha256 cellar: :any,                 arm64_sequoia: "2f0cbe5a7e76e379a975513eece85c5fb25eb96044a3c1f834a417ce5e6da344"
    sha256 cellar: :any,                 arm64_sonoma:  "2f0cbe5a7e76e379a975513eece85c5fb25eb96044a3c1f834a417ce5e6da344"
    sha256 cellar: :any,                 sonoma:        "f8de8cd80e5bb42f8e081cc2fb69f69d051a8451b9a145a9d5f022b45e2fbe38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b83d3058a502228ac3eb4bb3520bcc94360e86d1c917f11292346ae57905d4c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f969a9a777c24d592b6e65cf467d2aa5b3e8a6085e8408ca1ee5ed369751b4b"
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
