class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.15.1.tgz"
  sha256 "b3a1282ce19e854ff14ab0290df6923e29a042feb2b3cbee894a88d6c8170ac9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1fbd7cf88c90130243c514de9ad7881c0f5c4eefe5fbb168b0a22baec31d73a4"
    sha256 cellar: :any,                 arm64_sequoia: "ec443822e1401da74181af567fd81b60bb6aa53e4e9e8022b10c6b788cfc8017"
    sha256 cellar: :any,                 arm64_sonoma:  "ec443822e1401da74181af567fd81b60bb6aa53e4e9e8022b10c6b788cfc8017"
    sha256 cellar: :any,                 sonoma:        "d8cbad7dbef8e1f2374ea556671bc8acb96dda15505f9dde27cd182a1261a1ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b126c5d328f4025e1de7f97ab7d91fabb0433acabf245bb09dd59448d0b2d3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4bc71bb6c71efec2758ec437c1427cfff435f1f6bca082dca1211908dafe4dc"
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
