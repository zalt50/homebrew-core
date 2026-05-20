class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.31.0.tgz"
  sha256 "2b9bb5c5dc51030fea33fbc6f6d243062431dbb45eda50228ed6c40285cdde4c"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6b01af5e5977c5eb1d65853a59ab00e08b3c8825490a275bbb23d31395aa05e9"
    sha256 cellar: :any,                 arm64_sequoia: "e42796dd2ce4cd2dca382009e57b9895c385bb226485d5f25ef8cdbd9fb8be24"
    sha256 cellar: :any,                 arm64_sonoma:  "e42796dd2ce4cd2dca382009e57b9895c385bb226485d5f25ef8cdbd9fb8be24"
    sha256 cellar: :any,                 sonoma:        "595c86cbf1e6e74943319aba04c2a44c7dbe31801fea9526ceb33f5b2b59f609"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6774932d770df2c3ebd8d701d0a030d312b9c8986259c8fa0950c69c8ac23768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "555df9ab0b4a0611fa0e93e87fffc363906cdea160459b0ec281da181d5ee7c2"
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
