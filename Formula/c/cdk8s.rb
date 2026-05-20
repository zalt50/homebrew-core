class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.4.tgz"
  sha256 "659f01a3fae73fd294be3d0d02f5064bf648158f77d7a31ce7869856b396057b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9185283c9dda315ef49771c6e70f4fe7a92810ece1a997ee4fa9f8f92ce55573"
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
