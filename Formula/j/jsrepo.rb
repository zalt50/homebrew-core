class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-3.0.10.tgz"
  sha256 "e89c8752d3ae511e3e27f16345862c4ea3711e1456c5462bad16d4aa6eed9098"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b0dc13d262d2f8f228deff30aa60689270fd24bb0428a0d06f13703ddda07781"
    sha256 cellar: :any,                 arm64_sequoia: "91dab4f0a66d0d892f0e219958125cd2314e4cd90c7892cd026ada305c5ca3ce"
    sha256 cellar: :any,                 arm64_sonoma:  "91dab4f0a66d0d892f0e219958125cd2314e4cd90c7892cd026ada305c5ca3ce"
    sha256 cellar: :any,                 sonoma:        "95c50abf5ee984cbe328a3670342682955cc20e13c8e288ddacc8add1dc526b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b47147a28432ccd5b3fa21f0ff9816d0faba5a63879ba9d4eae20671b3d5b6e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70e7b0528880ca173204422eb5d3b9fd8306bd4d1e2c13933da384c6cb713ab7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0"
      }
    JSON
    system bin/"jsrepo", "init", "--yes"
  end
end
