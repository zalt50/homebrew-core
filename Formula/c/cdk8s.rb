class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.202.11.tgz"
  sha256 "f6adb6fb8c606ab4c96fe0bfc6fafb29f69550ba2b671be3b927aaa8cd3a3bf3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c8b7509c98efc4acb77c7bd3148960129272e0ba98a144839433b40552122385"
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
