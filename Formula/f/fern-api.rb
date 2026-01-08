class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.36.1.tgz"
  sha256 "f97d2da4ae4d6cb66f32e2d85d9cee7c1b941b949100a150ffeff2f177e2a490"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "37f2fc3e0fd5ea69e0539091911dc8e5e529fd66102a0bacaae1b513e9353cee"
    sha256 cellar: :any,                 arm64_sequoia: "c0062be6c855aa8d549d907540663f6cbe9c39dc390c0bbcac0ec8b6f5d36461"
    sha256 cellar: :any,                 arm64_sonoma:  "c0062be6c855aa8d549d907540663f6cbe9c39dc390c0bbcac0ec8b6f5d36461"
    sha256 cellar: :any,                 sonoma:        "7e1236a34df219ae991ccfb119810fcf3adaa83ff741dcff0759eb69be44a747"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bf005d9332a5fe7c82d0d2f4044ff032c6115da1ec2a0520bb9a45904b5b9cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "122bc11389716258407706aa58887f3739db24bd9201a8aaf59422849d7e6006"
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
