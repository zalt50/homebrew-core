class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.1.0.tgz"
  sha256 "1704c222401994f8566f173fd1456fd5add02d92d66bd4d5bff795dd63af9e98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "564406e951e65086e59d2a6b584e739e01c40f0852a2780dba161c773125daca"
    sha256 cellar: :any,                 arm64_sequoia: "d136b79af13cfa90f9b8bb5aad7f46f80a802625fa7d252637232621a56a7d20"
    sha256 cellar: :any,                 arm64_sonoma:  "d136b79af13cfa90f9b8bb5aad7f46f80a802625fa7d252637232621a56a7d20"
    sha256 cellar: :any,                 sonoma:        "f1d980ba4da3b219ca36f042c7466848b7cf20e9dfbbcafd4752d0f03de44cdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e228ee001c0b6787665e8085ecf5f61f2777d222b6426630f614733572c90dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "481af1d6fe3e6e22eff0ae3a703cc13edcdc3525a3f20a89f754c1e836f84fd6"
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
