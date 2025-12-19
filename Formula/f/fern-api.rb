class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.27.3.tgz"
  sha256 "7983f6bfae0ed314eb4d053ce9d0a0d881a4bcdb0ccdbc79660b04b4bbca98f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "87ec920b41f143e74655ee5d36e9c870b1549f8c792d673e0e5597511366296f"
    sha256 cellar: :any,                 arm64_sequoia: "ea71da6f7291c43fb0733e09789c8cd5e130e9627baefc41a43296d80fbd6e09"
    sha256 cellar: :any,                 arm64_sonoma:  "ea71da6f7291c43fb0733e09789c8cd5e130e9627baefc41a43296d80fbd6e09"
    sha256 cellar: :any,                 sonoma:        "ab6619959e3834c03ceabe7ce29e5abcef7c8ee8c4ea074080ebc87781ace423"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d8e67befdce54119e1bfb814d505bf61227ffc5a7007695c48151c58211e4a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "605c71b2161636de7222996cf93e812115cebdc8d53b74abd915176762f962eb"
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
