class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.14.tgz"
  sha256 "5064795e2b1eea144f33edf953dd10b7742447a7f591af1bcb268a6353d568be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e6978edf178183792b950539fc77ae99332354b48c397c0945c71b1de9fa62ee"
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
