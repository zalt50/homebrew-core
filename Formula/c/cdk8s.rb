class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.29.tgz"
  sha256 "b4c9137ecd2eb22e561db4588381bee206e02de1e7dbd19d7fd7bb6e5cd284e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "80a7c81ab4202c59047f06f45ba6cee1613d5f7c9df86ee44aeae0172f2cc8aa"
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
