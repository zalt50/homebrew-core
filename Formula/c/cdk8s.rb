class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.51.tgz"
  sha256 "959e6207115ac5e15f6765f4669669875a75db9c771c90a0e0b73d037fb253ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a5a75eb3fb169d458bb7da44e5122be5b3a0b610b2227e0d0b0bf34506058577"
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
