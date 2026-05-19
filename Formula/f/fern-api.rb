class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.29.0.tgz"
  sha256 "98ca5609ab37387c5c3186b20eb03db3eafaf65252bb1520ff77d08c168cc5ab"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e7e01a0a9fda2c4103245baca1d3db7563a3ab8bd5df5ca62e13c5792f2e2a49"
    sha256 cellar: :any,                 arm64_sequoia: "2e6f47db07d25ffe45939bdab16973a5f7fd4555c5b5a527a3e61b04b922bc5d"
    sha256 cellar: :any,                 arm64_sonoma:  "2e6f47db07d25ffe45939bdab16973a5f7fd4555c5b5a527a3e61b04b922bc5d"
    sha256 cellar: :any,                 sonoma:        "9df59be0c24cb0a91a81dcc43f9fc045de1d7e99c53c1e8650b724b42294470b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3ec097ca7c641245c0bd54e50aba9ade527c2f02176650eaf4e8319f3e772d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3367810d9c4c582318c75117c6e1f25343ba316f0617452382ab4bf6e07a845"
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
