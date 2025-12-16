class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.203.6.tgz"
  sha256 "99bda4513277c4b45d118c32d9f28fdf484fd6bc202ae760f700fe401b0cb2e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2f71276742af0cf2c9a73b41dd8a91a7456cc4b3c16b4acbfa743f61fe171135"
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
