class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.5.tgz"
  sha256 "cb7d75fcd559ad5896a83dc97f7b218b2f1b7b1f6b0817da7b720e2611cec36e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cb2b0c8cb0a75001f0ac224c24a2ba4e8964bd840fc0a132cc336d687a7cbbb5"
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
