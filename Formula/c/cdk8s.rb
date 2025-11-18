class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.203.3.tgz"
  sha256 "5e809c16f3b1b422b716cc7ad9a3f5b037620bf9cade275fb1e9f188a41ccff0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "17807827d64d16da121659432d6bab4459935f0bafe73ae57f4b111b276878a7"
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
