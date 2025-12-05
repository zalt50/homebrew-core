class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.2.0.tgz"
  sha256 "391be55bc57289b1e807df572d9331dd061d60f92d33caf300f15b8c2c1d2ccb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "70d413d2623abf69a91fdb8e2b092e1753268c44dfe3463e6335ec7f08ed7696"
    sha256 cellar: :any,                 arm64_sequoia: "8721cf080edc280dd9480e750d4bbb745022dd30e17d885f5dedf0cc48a719cb"
    sha256 cellar: :any,                 arm64_sonoma:  "8721cf080edc280dd9480e750d4bbb745022dd30e17d885f5dedf0cc48a719cb"
    sha256 cellar: :any,                 sonoma:        "264d8f648ca6d50e30458af2e3c0738db88225b0b9220c4f57409af345ac22c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f8fe66334901476b79d68e4be68df5449211fdccebc0f45e1d9f0710bb4139f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28de0868219fbc5b9ca905ef85d58a96a16480a70d59970f26fff859fdfaa47d"
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
