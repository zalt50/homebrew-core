class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.203.2.tgz"
  sha256 "3cf6f4dae7e12b3bb966f381c977e5e8b2c4e7b66d955e4aa1c29f5bcabc3695"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d9e832f98576dfe18cc998d6e722805fb2d38ec40432cfd004721b6539d9acc2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
