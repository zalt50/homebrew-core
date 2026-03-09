class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.16.0.tgz"
  sha256 "ec99397b5e2fb33e950e8b7cf92e4bcb44c6451e37a873854aa9a1bb2fd57df5"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "356ceea70c40038bc2088bb35ecc13c05d72ada1162ed77094ffbf5fb2615f02"
    sha256 cellar: :any,                 arm64_sequoia: "bdd6eb77a35616f1bad25e24e8999e1c21cc8631ff42bb117ab77e80aef53bde"
    sha256 cellar: :any,                 arm64_sonoma:  "bdd6eb77a35616f1bad25e24e8999e1c21cc8631ff42bb117ab77e80aef53bde"
    sha256 cellar: :any,                 sonoma:        "b5590ea0254657b0fdf9a3bca689d85d1c4bca787e6660b5919bb7f3269c8ce5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8239fec4fcc2e55e045686f7b2d55a3b861b51704a434a6575a1ee0cebdd7743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0ec099e6f58b0f3b91c92c123f0f0326029425d48945e47eb2639cf4ef9688a"
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
