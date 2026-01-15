class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.203.17.tgz"
  sha256 "d11fc0cb387095e59facc7ec25fad38ac7574797ba84f68ad46a718cb7ed5057"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "737da2532d46781cbc04f14455cd19073eee73a7b1b8fcb2f5d83fd18a5bd842"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
