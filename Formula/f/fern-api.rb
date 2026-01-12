class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.38.0.tgz"
  sha256 "92dac2c2e7460525d85fff0625c7079a2cc3152465872faeae9892bb9b5e032c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e91d91397ed6dcb7ee0c9d0ff0510f16f645d3ee0690ec7202a320bddb36548"
    sha256 cellar: :any,                 arm64_sequoia: "d21d8e899c3fb34654883277525f045e7147d1ba5a607fa25cc7866662e9b4df"
    sha256 cellar: :any,                 arm64_sonoma:  "d21d8e899c3fb34654883277525f045e7147d1ba5a607fa25cc7866662e9b4df"
    sha256 cellar: :any,                 sonoma:        "c7b76f760f2d899289984f957f829fd1f1b03483faeb5cf8c51b5bb7c9b5caa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "889e2a9a50c3a5979250d1b3e4c691d881eb237263c74250c58f06fd299df0b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2acf4aacbae0910b89d2702ecc365c3875cfad35f7411fe67c808e52af901ecb"
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
