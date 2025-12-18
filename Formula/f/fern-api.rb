class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.26.1.tgz"
  sha256 "77fd117254632b420aaca8681d2e47bad06efe3969774bce3e0f31a2e9b50bb9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "29611247bd9863179c94df77bef83d592ddf8a29dc43cf659e1269c56c080ba5"
    sha256 cellar: :any,                 arm64_sequoia: "4545a5faecd22d284d8111e45b63d98d8324399d94a4c3fb99492521c5cd896d"
    sha256 cellar: :any,                 arm64_sonoma:  "4545a5faecd22d284d8111e45b63d98d8324399d94a4c3fb99492521c5cd896d"
    sha256 cellar: :any,                 sonoma:        "807661d4e2154410fef575d38112e369ca6dc4ed0b59693cb1045c8b9a721303"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2125f903b341bc898932043750d8e3faed4ce2e9987a2d0dbb494aa0b1fccd22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b201b93494adfccffb5d2ae1c9eee3dd843dd24df23b52f354ea96dc0340624"
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
