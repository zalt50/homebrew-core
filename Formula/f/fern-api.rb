class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.40.0.tgz"
  sha256 "82550e204423ccc17527888f9c307327566e9b70f208aec5f8e1f1bf39d3ea68"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9c19d4def611be3385bd2963421e5dbc50ef78e28cb8b35df7444177efc09278"
    sha256 cellar: :any,                 arm64_sequoia: "678cc131d135506efa198f30059d3b2ae4bffa05263a3a233038501fcaac3867"
    sha256 cellar: :any,                 arm64_sonoma:  "678cc131d135506efa198f30059d3b2ae4bffa05263a3a233038501fcaac3867"
    sha256 cellar: :any,                 sonoma:        "432195082537fcf5ab108425f08ab61c87274112281f677613d6fe39a71a3ca1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bb5a5b1583b869fb421539ddbc193e01c0717e5d9ffb3aa018d30f036125752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d64c6f7a9948f0c74bd9a7e366c81ff2451e84859edc79db36de1154b90ed00"
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
